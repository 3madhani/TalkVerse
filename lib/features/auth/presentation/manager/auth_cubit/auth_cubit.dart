import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:chitchat/features/auth/domain/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> signUp({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepo.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (
      userEntity,
    ) async {
      // Send verification email
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      emit(AuthVerificationRequired(userEntity));
    });
  }

  Future<void> checkEmailVerification() async {
    emit(AuthLoading());
    await FirebaseAuth.instance.currentUser?.reload();
    final isVerified =
        FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (isVerified) {
      final user = FirebaseAuth.instance.currentUser!;
      final userEntity = UserModel.fromFirebaseUser(user);
      emit(AuthSuccess(userEntity));
    } else {
      emit(const AuthFailure('Please verify your email first.'));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (userEntity) => emit(AuthSuccess(userEntity)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    final result = await authRepo.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (userEntity) => emit(AuthWithSocialSuccess(userEntity)),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(AuthLoading());
    final result = await authRepo.signInWithFacebook();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (userEntity) => emit(AuthSuccess(userEntity)),
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    final result = await authRepo.signOut();
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }
}
