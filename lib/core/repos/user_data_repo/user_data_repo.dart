import 'package:dartz/dartz.dart';

import '../../../features/auth/domain/entities/user_entity.dart';
import '../../errors/failure.dart';

abstract class UserDataRepo {
  Stream<Either<Failure, UserEntity>> getUserData(String userId);

  Stream<Either<Failure, List<UserEntity>>> getUsersData(List<String> usersIds);

  Future<Either<Failure, void>> updateUserData({
    required Map<String, dynamic> data,
  });

  Future<void> updateUserLastSeen(bool online);

  Future<Either<Failure, void>> updateUserPushToken(String pushToken);
}
