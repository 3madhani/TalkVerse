import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../features/auth/data/model/user_model.dart';
import '../../constants/backend/backend_end_points.dart';
import '../../errors/failure.dart';
import '../../services/database_services.dart';
import 'user_data_repo.dart';

class UserDataRepoImpl implements UserDataRepo {
  DatabaseServices databaseServices;
  UserDataRepoImpl({required this.databaseServices});
  @override
  Stream<Either<Failure, UserModel>> getUserData(String userId) async* {
    try {
      await FirebaseMessaging.instance.getToken().then(
        (value) => {
          if (value != null) {updateUserPushToken(value)},
        },
      );

      yield* databaseServices
          .fetchUser(path: BackendEndPoints.getUser, documentId: userId)
          .map((data) {
            if (data != null && data.isNotEmpty) {
              return Right(UserModel.fromJson(data));
            } else {
              return const Left(ServerFailure("User not found"));
            }
          });
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<UserModel>>> getUsersData(
    List<String> usersIds,
  ) async* {
    try {
      yield* databaseServices
          .fetchUser(path: BackendEndPoints.getUser, listOfIds: usersIds)
          .map((data) {
            final users =
                data?.map<UserModel>((e) => UserModel.fromJson(e)).toList() ??
                [];
            if (users.isNotEmpty) {
              return Right(users);
            } else {
              return const Left(ServerFailure("No user data found"));
            }
          });
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserData({
    required Map<String, dynamic> data,
  }) async {
    try {
      await databaseServices.updateData(
        path: BackendEndPoints.addUsers,
        data: data,
        documentId: FirebaseAuth.instance.currentUser!.uid,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> updateUserLastSeen(bool online ) async {
    await databaseServices.updateData(
      path: BackendEndPoints.addUsers,
      data: {"online": online, "lastSeen": DateTime.now().millisecondsSinceEpoch.toString()},
      documentId: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  @override
  Future<Either<Failure, void>> updateUserPushToken(String pushToken) async {
    try {
      await databaseServices.updateData(
        path: BackendEndPoints.addUsers,
        data: {"pushToken": pushToken},
        documentId: FirebaseAuth.instance.currentUser!.uid,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
