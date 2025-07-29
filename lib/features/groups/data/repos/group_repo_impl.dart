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
        about: '',
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
  Stream<Either<Failure, List<GroupEntity>>> getGroups() {
    throw UnimplementedError();
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
