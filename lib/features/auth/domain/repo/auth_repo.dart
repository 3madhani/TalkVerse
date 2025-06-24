import 'package:chitchat/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/user_entity.dart';

abstract class AuthRepo {
  Future addUserData({required UserEntity userEntity});

  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity> getUserData({required String uId});

  Future saveUserData({required UserEntity userEntity});

  Future<void> sendPasswordResetEmail({required String email});

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithFacebook();

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();
  Future<void> verifyEmail();
}
