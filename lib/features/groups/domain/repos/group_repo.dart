import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/group_entity.dart';

abstract class GroupRepo {
  Future<Either<Failure, void>> createGroup({
    required String groupName,
    required List<String> members,
    String? imageUrl,
  });

  Future<Either<Failure, void>> deleteGroup(String groupId);

  Stream<Either<Failure, List<String>>> fetchMembers(List<String> memberIds);

  Stream<Either<Failure, List<GroupEntity>>> getGroups();

  Future<Either<Failure, void>> updateGroup(
    String groupId,
    String groupName,
    List<String> members,
  );
}
