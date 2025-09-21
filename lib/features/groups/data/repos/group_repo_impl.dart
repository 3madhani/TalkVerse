import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/database_services.dart';
import '../../../../core/services/shared_preferences_singleton.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repos/group_repo.dart';
import '../models/group_model.dart';

class GroupRepoImpl implements GroupRepo {
  final DatabaseServices databaseServices;
  GroupRepoImpl({required this.databaseServices});
  User? get _currentUser => FirebaseAuth.instance.currentUser;
  String? get _myId => _currentUser!.uid;

  @override
  Future<Either<Failure, void>> addAdmin(String groupId, String userId) async {
    try {
      await databaseServices.updateData(
        path: BackendEndPoints.groups,
        documentId: groupId,
        data: {
          'admins': FieldValue.arrayUnion([userId]),
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createGroup({
    required String groupName,
    required List<String> members,
    String? imageUrl,
  }) async {
    try {
      String groupId = const Uuid().v1();
      // Create a GroupModel with a new ID
      final groupModel = GroupModel(
        about:
            'This is a group created by ${FirebaseAuth.instance.currentUser!.displayName}',
        name: groupName,
        members: [_myId!, ...members],
        id: groupId,
        admins: [_myId!],
        createdBy: _myId!,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        lastMessage: '',
        lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: imageUrl ?? '',
      );

      await databaseServices.setData(
        path: BackendEndPoints.groups,
        documentId: groupId,
        data: groupModel.toJson(),
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Delete group
  @override
  Future<Either<Failure, String>> deleteGroup(String groupId) async {
    try {
      // Delete from Firestore
      await databaseServices.deleteData(
        path: BackendEndPoints.groups,
        documentId: groupId,
      );

      // Remove cached messages
      await Prefs.remove('messages_$groupId');

      // Remove from cached groups
      final cachedJson = Prefs.getString('cachedGroups');
      if (cachedJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cachedJson);
        final updatedList = decoded.where((e) => e['id'] != groupId).toList();
        await Prefs.setString('cachedGroups', jsonEncode(updatedList));
      }

      return const Right("Group deleted successfully");
    } catch (e, stack) {
      log("🔥 deleteGroup error: $e", stackTrace: stack);
      return const Left(ServerFailure("Failed to delete group"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMember(
    String groupId,
    String memberId,
  ) async {
    try {
      await databaseServices.deleteData(
        path: BackendEndPoints.groups,
        documentId: groupId,
        queryParameters: {'memberId': memberId},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Listen to groups for the current user
  @override
  Stream<Either<Failure, List<GroupEntity>>> getGroups() {
    try {
      return databaseServices
          .streamData(
            path: BackendEndPoints.groups,
            queryParameters: {
              "field": "members",
              "arrayContains": _myId,
              "orderBy": "lastMessageTime",
              "descending": true,
            },
          )
          .map((list) {
            try {
              final groups =
                  (list as List)
                      .cast<Map<String, dynamic>>()
                      .map((e) => GroupModel.fromJson(e))
                      .toList();

              groups.sort((a, b) {
                final aTime = _parseDate(a.lastMessageTime, a.createdAt);
                final bTime = _parseDate(b.lastMessageTime, b.createdAt);
                return bTime.compareTo(aTime);
              });

              return Right(groups);
            } catch (e) {
              log("🔥 mapping groups error: $e");
              return const Left(ServerFailure("Failed to map groups"));
            }
          });
    } catch (e, stack) {
      log("🔥 getGroups error: $e", stackTrace: stack);
      return Stream.value(const Left(ServerFailure("Fetch failed")));
    }
  }

  @override
  Future<Either<Failure, void>> removeAdmin(
    String groupId,
    String userId,
  ) async {
    try {
      await databaseServices.updateData(
        path: BackendEndPoints.groups,
        documentId: groupId,
        data: {
          'admins': FieldValue.arrayRemove([userId]),
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, GroupEntity>> streamGroup(String groupId) async* {
    try {
      yield* databaseServices
          .streamData(path: BackendEndPoints.groups, documentId: groupId)
          .map((data) {
            try {
              return Right(GroupModel.fromJson(data));
            } catch (e) {
              log("🔥 mapping groups error: $e");
              return const Left(ServerFailure("Failed to map groups"));
            }
          });
    } catch (e, stack) {
      log("🔥 getGroups error: $e", stackTrace: stack);
      yield const Left(ServerFailure("Fetch failed"));
    }
  }

  /// Update group details
  @override
  Future<Either<Failure, String>> updateGroup(
    String groupId,
    String groupName,
    List<String> member,
  ) async {
    try {
      await databaseServices.updateData(
        path: BackendEndPoints.groups,
        documentId: groupId,
        data: {"name": groupName, "members": member},
      );

      return const Right("Group updated successfully");
    } catch (e, stack) {
      log("🔥 updateGroup error: $e", stackTrace: stack);
      return const Left(ServerFailure("Failed to update group"));
    }
  }

  DateTime _parseDate(String? value, String fallback) {
    try {
      value ??= fallback;
      return RegExp(r'^\d+$').hasMatch(value)
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(value))
          : DateTime.parse(value);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}
