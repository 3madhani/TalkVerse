part of 'group_cubit.dart';

final class GroupDeleted extends GroupState {
  final String name; // ID of the deleted group
  const GroupDeleted(this.name);
}

final class GroupError extends GroupState {
  final String message; // Error message
  const GroupError(this.message);
}

final class GroupInitial extends GroupState {}

final class GroupLoaded extends GroupState {
  final List<GroupEntity> groups; // List of groups
  const GroupLoaded(this.groups);

  @override
  List<Object> get props => [groups];
}

final class GroupLoading extends GroupState {}

sealed class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

final class GroupSuccess extends GroupState {
  final String message;
  const GroupSuccess(this.message);
}

final class GroupUpdated extends GroupState {
  final String message; // Updated group
  const GroupUpdated(this.message);
}
