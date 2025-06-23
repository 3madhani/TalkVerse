import 'dart:convert';
import 'dart:developer';

import 'package:chitchat/core/constants/backend/app_consts.dart';
import 'package:chitchat/core/constants/backend/backend_end_points.dart';
import 'package:chitchat/core/errors/failure.dart';
import 'package:chitchat/core/services/database_services.dart';
import 'package:chitchat/core/services/firebase_auth_service.dart';
import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/exception.dart';
import '../../../../core/services/shared_preferences_singleton.dart';
import '../../domain/repo/auth_repo.dart';
import '../model/user_model.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseServices databaseServices;

  AuthRepoImpl({
    required this.firebaseAuthService,
    required this.databaseServices,
  });
  @override
  Future addUserData({required UserEntity userEntity}) async {
    await databaseServices.setData(
      path: BackendEndPoints.addUsers,
      data: UserModel.fromEntity(userEntity).toJson(),
      documentId: userEntity.uId,
    );
  }

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    User? user;
    try {
      await firebaseAuthService.verifyEmail();

      var isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      if (!isEmailVerified) {
        throw CustomException(
          message: 'Please verify your email first. Check your inbox.',
        );
      }
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userEntity = UserEntity(
        uId: user.uid,
        email: email,
        name: name,
        photoUrl: '',
      );
      await addUserData(userEntity: userEntity);
      return Right(userEntity);
    } on CustomException catch (e) {
      await deleteUser(user);
      return left(ServerFailure(e.message));
    } catch (e) {
      await deleteUser(user);
      log("Error in createUserWithEmailAndPassword: ${e.toString()}");
      return left(const ServerFailure('Unexpected Error happened.'));
    }
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }

  @override
  Future<UserEntity> getUserData({required String uId}) async {
    var data = await databaseServices.getData(
      path: BackendEndPoints.getUser,
      documentId: uId,
    );
    return UserModel.fromJson(data);
  }

  @override
  Future saveUserData({required UserEntity userEntity}) async {
    var jsonData = jsonEncode(UserModel.fromEntity(userEntity).toJson());
    await Prefs.setString(AppConsts.userData, jsonData);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      var userEntity = await getUserData(uId: user.uid);
      await saveUserData(userEntity: userEntity);
      return Right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log("Error in signInWithEmailAndPassword: ${e.toString()}");
      return left(
        const ServerFailure(
          'Unexpected Error happened while signing in, try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithFacebook();

      var isUserExist = await databaseServices.checkIfDocumentExists(
        path: BackendEndPoints.getUser,
        documentId: user.uid,
      );

      UserEntity userEntity;
      if (isUserExist) {
        userEntity = await getUserData(uId: user.uid);
      } else {
        userEntity = UserModel.fromFirebaseUser(user);
        await addUserData(userEntity: userEntity);
      }

      await saveUserData(userEntity: userEntity);
      return Right(userEntity);
    } catch (e) {
      await deleteUser(user);
      log("Error in signInWithFacebook: ${e.toString()}");
      return left(
        const ServerFailure(
          'Unexpected Error happened while signing in, try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();

      var isUserExist = await databaseServices.checkIfDocumentExists(
        path: BackendEndPoints.getUser,
        documentId: user.uid,
      );

      UserEntity userEntity;
      if (isUserExist) {
        userEntity = await getUserData(uId: user.uid);
      } else {
        userEntity = UserModel.fromFirebaseUser(user);
        await addUserData(userEntity: userEntity);
      }

      await saveUserData(userEntity: userEntity);
      return Right(userEntity);
    } catch (e) {
      await deleteUser(user);
      log("Error in signInWithGoogle: ${e.toString()}");
      return left(
        const ServerFailure(
          'Unexpected Error happened while signing in, try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await firebaseAuthService.signOut();
      return const Right(null);
    } catch (e) {
      log("Error in signOut: ${e.toString()}");
      return left(
        const ServerFailure(
          'Unexpected Error happened while signing out, try again later.',
        ),
      );
    }
  }

  @override
  Future<void> verifyEmail() async {
    await firebaseAuthService.verifyEmail();
  }
}
