import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/user_model.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repo/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(const AuthInitial());

  Future<void> addUserToFirebase(UserEntity userEntity) async {
    emit(const AuthLoading());

    final result = await authRepo.addUserData(userEntity: userEntity);

    result.fold((failure) => emit(AuthFailure(failure.message)), (_) async {
      await authRepo.saveUserData(userEntity: userEntity);
      emit(AuthSuccess(userEntity));
    });
  }

  Future<void> checkEmailVerification() async {
    emit(const AuthLoading());

    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final isVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;

      if (isVerified) {
        final user = FirebaseAuth.instance.currentUser!;
        final userEntity = UserModel.fromFirebaseUser(user);
        emit(AuthSuccess(userEntity));
      } else {
        emit(const AuthFailure('Email is not verified yet.'));
      }
    } catch (e) {
      emit(AuthFailure('Failed to check verification: $e'));
    }
  }

  Future<void> checkIfLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      try {
        final userEntity = await authRepo.getUserData(uId: user.uid);
        emit(AuthSuccess(userEntity));
      } catch (e) {
        emit(AuthFailure('Failed to fetch user data: $e'));
      }
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());

    final result = await authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (userEntity) {
      final isVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      if (!isVerified) {
        emit(const AuthVerificationRequired());
      } else {
        emit(AuthSuccess(userEntity));
      }
    });
  }

  Future<void> signInWithFacebook() async {
    emit(const AuthLoading());

    final result = await authRepo.signInWithFacebook();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (userEntity) => emit(AuthWithSocialSuccess(userEntity)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());

    final result = await authRepo.signInWithGoogle();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (userEntity) => emit(AuthWithSocialSuccess(userEntity)),
    );
  }

  Future<void> signOut() async {
    emit(const AuthLoading());

    final result = await authRepo.signOut();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthInitial()),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await authRepo.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) =>
          emit(const AuthVerificationRequired()), // ✅ Now this will be emitted
    );
  }
}
