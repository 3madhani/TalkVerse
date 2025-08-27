import 'package:dartz/dartz.dart';

import '../../../features/auth/domain/entities/user_entity.dart';
import '../../errors/failure.dart';

abstract class UserDataRepo {
  Stream<Either<Failure, UserEntity>> getUserData(String userId);

  Stream<Either<Failure, List<UserEntity>>> getUsersData(List<String> usersIds);


  Future<void> updateUserContacts(String userId, List<String> contactIds);
  Future<Either<Failure, void>> updateUserData({
    required Map<String, dynamic> data
  });

  Future<void> updateUserLastSeen(String userId, DateTime lastSeen);

  Future<Either<Failure, void>> updateUserPushToken(
    String userId,
    String pushToken,
  );
}
