part of 'auth_cubit.dart';

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthVerificationRequired extends AuthState {
  final UserEntity user;
  const AuthVerificationRequired(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthWithSocialSuccess extends AuthState {
  final UserEntity user;
  const AuthWithSocialSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
