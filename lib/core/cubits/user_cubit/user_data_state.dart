part of 'user_data_cubit.dart';

sealed class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

final class UserDataInitial extends UserDataState {}

final class UserDataLoading extends UserDataState {}
final class UserDataLoaded extends UserDataState {
  final UserEntity user;

  const UserDataLoaded(this.user);

  @override
  List<Object> get props => [user];
}

final class UsersDataLoaded extends UserDataState {
  final List<UserEntity> user;

  const UsersDataLoaded(this.user);

  @override
  List<Object> get props => [user];
}

final class UserDataError extends UserDataState {
  final String message;

  const UserDataError(this.message);

  @override
  List<Object> get props => [message];
}

final class UserDataUpdated extends UserDataState {
  final String message;

  const UserDataUpdated(this.message);
}
final class UserDataUpdateError extends UserDataState {
  final String message;

  const UserDataUpdateError(this.message);

  @override
  List<Object> get props => [message];
}

