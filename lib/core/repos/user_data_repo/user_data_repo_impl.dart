import 'package:dartz/dartz.dart';

import '../../../features/auth/data/model/user_model.dart';
import '../../constants/backend/backend_end_points.dart';
import '../../errors/failure.dart';
import '../../services/database_services.dart';
import 'user_data_repo.dart';

class UserDataRepoImpl implements UserDataRepo {
  DatabaseServices databaseServices;
  UserDataRepoImpl({required this.databaseServices});
  @override
  Stream<Either<Failure, List<UserModel>>> getUserData(String userId) async* {
    try {
      yield* databaseServices
          .streamData(path: BackendEndPoints.getUser, documentId: userId)
          .map((data) => Right(data ?? []));
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> updateUserAbout(String userId, String about) {
    // TODO: implement updateUserAbout
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserContacts(String userId, List<String> contactIds) {
    // TODO: implement updateUserContacts
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateUserData({
    required String name,
    required String profilePictureUrl,
  }) {
    // TODO: implement updateUserData
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserLastSeen(String userId, DateTime lastSeen) {
    // TODO: implement updateUserLastSeen
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateUserPushToken(
    String userId,
    String pushToken,
  ) {
    // TODO: implement updateUserPushToken
    throw UnimplementedError();
  }
}
