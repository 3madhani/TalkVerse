import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthVerificationRequired extends AuthState {
  const AuthVerificationRequired();
}

class AuthWithSocialSuccess extends AuthState {
  final UserEntity user;
  const AuthWithSocialSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
