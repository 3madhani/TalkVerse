// Updated ChatRoomRepoImpl with proper cache cleanup
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/database_services.dart';
import '../../../../core/services/shared_preferences_singleton.dart';
import '../../../auth/data/model/user_model.dart';
import '../../domain/entities/chat_room_entity.dart';
import '../../domain/repos/chat_room_repo.dart';
import '../models/chat_room_model.dart';

class ChatRoomRepoImpl implements ChatRoomRepo {
  final DatabaseServices databaseServices;

  ChatRoomRepoImpl({required this.databaseServices});

  @override
  Future<Either<Failure, String>> createChatRoom(String email) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return const Left(ServerFailure("User not logged in"));
      }

      final userId = user.uid;
      final users = await databaseServices.getData(
        path: BackendEndPoints.getUser,
        queryParameters: {"where": "email", "isEqualTo": email},
      );

      if (users == null || users.isEmpty) {
        return const Left(ServerFailure("User not found"));
      }

      final otherUser = UserModel.fromJson(users.first);
      final chatRoomId = _generateChatRoomId(userId, otherUser.uId);

      if (await isExist(chatRoomId)) {
        return const Right("Chat room already exists, can't create again");
      }

      final chatRoom = ChatRoomModel(
        id: chatRoomId,
        members: [userId, otherUser.uId],
        roomNames: {
          userId: otherUser.name ?? "User",
          otherUser.uId: user.displayName ?? "Unknown",
        },
      );

      await databaseServices.setData(
        path: BackendEndPoints.chatRooms,
        data: chatRoom.toJson(),
        documentId: chatRoomId,
      );

      return const Right("Chat room created successfully");
    } catch (e, stack) {
      log("🔥 createChatRoom error: $e", stackTrace: stack);
      return const Left(ServerFailure("Failed to create chat room"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteChatRoom(String chatRoomId) async {
    try {
      // Delete chat room from Firestore
      await databaseServices.deleteData(
        path: BackendEndPoints.chatRooms,
        documentId: chatRoomId,
      );

      // Delete messages cache
      await Prefs.remove('messages_$chatRoomId');

      // Update cached chat rooms
      final cachedJson = Prefs.getString('cachedChatRooms');
      if (cachedJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cachedJson);
        final updatedList =
            decoded.where((e) => e['id'] != chatRoomId).toList();
        await Prefs.setString('cachedChatRooms', jsonEncode(updatedList));
      }

      return const Right("Chat room deleted successfully");
    } catch (e, stack) {
      log("🔥 deleteChatRoom error: $e", stackTrace: stack);
      return const Left(ServerFailure("Failed to delete chat room"));
    }
  }

  @override
  Stream<Either<Failure, List<ChatRoomEntity>>> fetchUserChatRooms({
    required String userId,
  }) {
    try {
      return databaseServices
          .streamData(
            path: BackendEndPoints.chatRooms,
            queryParameters: {
              "field": "members",
              "arrayContains": userId,
              "orderBy": "lastMessageTime",
              "descending": true,
            },
          )
          .map((list) {
            try {
              final rooms =
                  (list as List)
                      .cast<Map<String, dynamic>>()
                      .map((e) => ChatRoomModel.fromJson(e).toEntity(userId))
                      .toList();

              rooms.sort((a, b) {
                final aTime = _parseDate(a.lastMessageTime, a.createdAt);
                final bTime = _parseDate(b.lastMessageTime, b.createdAt);
                return bTime.compareTo(aTime);
              });

              return Right(rooms);
            } catch (e) {
              log("🔥 mapping chat rooms error: $e");
              return const Left(ServerFailure("Failed to map chat rooms"));
            }
          });
    } catch (e, stack) {
      log("🔥 fetchUserChatRooms error: $e", stackTrace: stack);
      return Stream.value(const Left(ServerFailure("Fetch failed")));
    }
  }

  Future<bool> isExist(String chatRoomId) async {
    try {
      final result = await databaseServices.getData(
        path: BackendEndPoints.chatRooms,
        documentId: chatRoomId,
      );
      return result != null && result.isNotEmpty;
    } catch (e, stack) {
      log("🔥 isExist error: $e", stackTrace: stack);
      return false;
    }
  }

  String _generateChatRoomId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return sorted.join('_');
  }

  DateTime _parseDate(String? value, String fallback) {
    try {
      value ??= fallback;
      return RegExp(r'^\d+\$').hasMatch(value)
          ? DateTime.fromMillisecondsSinceEpoch(int.parse(value))
          : DateTime.parse(value);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }
}
