import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/v1.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/database_services.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repos/group_repo.dart';
import '../models/group_model.dart';

class GroupRepoImpl implements GroupRepo {
  final DatabaseServices databaseServices;
  final String _myId = FirebaseAuth.instance.currentUser!.uid;
  final now = DateTime.now().microsecondsSinceEpoch.toString();
  GroupRepoImpl({required this.databaseServices});

  @override
  Future<Either<Failure, void>> createGroup({
    required String groupName,
    required List<String> members,
    String? imageUrl,
  }) async {
    try {
      // Create a GroupModel with a new ID
      final groupModel = GroupModel(
        about:
            'This is a group created by ${FirebaseAuth.instance.currentUser!.displayName}',
        name: groupName,
        members: [_myId, ...members],
        id: const UuidV1().toString(),
        admins: [_myId],
        createdBy: _myId,
        createdAt: now,
        lastMessage: '',
        lastMessageTime: now,
        imageUrl: imageUrl ?? '',
      );

      await databaseServices.setData(
        path: BackendEndPoints.groups,
        data: groupModel.toJson(),
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String groupId) {
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, List<GroupEntity>>> getGroups() async* {
    try {
      yield* databaseServices
          .streamData(
            path: BackendEndPoints.groups,
            queryParameters: {
              'field': 'members',
              'arrayContains': _myId, // Your current user ID
              'orderBy': 'createdAt',
              'descending': true,
            },
          )
          .map((snapshotData) {
            try {
              if (snapshotData is List) {
                final groups =
                    snapshotData
                        .map(
                          (data) => GroupModel.fromJson(data),
                        ) // Convert Map → Model
                        .toList();
                return Right<Failure, List<GroupEntity>>(groups);
              } else {
                return const Left<Failure, List<GroupEntity>>(
                  ServerFailure('Unexpected data format'),
                );
              }
            } catch (e) {
              return Left<Failure, List<GroupEntity>>(
                ServerFailure(e.toString()),
              );
            }
          });
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGroup(
    String groupId,
    String groupName,
    String groupDescription,
  ) {
    throw UnimplementedError();
  }
}
