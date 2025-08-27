part of 'user_data_cubit.dart';

class UserDataError extends UserDataState {
  final String message;
  const UserDataError(this.message);
}

final class UserDataInitial extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final UserEntity user;
  final bool isFromCache;
  const UserDataLoaded(this.user, {this.isFromCache = false});

  @override
  List<Object> get props => [user, isFromCache];
}

final class UserDataLoading extends UserDataState {}

sealed class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
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

class UsersDataLoaded extends UserDataState {
  final List<UserEntity> users;
  final bool isFromCache;
  const UsersDataLoaded(this.users, {this.isFromCache = false});
  @override
  List<Object> get props => [users, isFromCache];
}
