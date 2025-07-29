import 'package:chitchat/features/groups/domain/repos/group_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/group_entity.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepo groupRepo;
  GroupCubit(this.groupRepo) : super(GroupInitial());

  Future<void> createGroup({
    required String groupName,
    required List<String> members,
    String? imageUrl,
  }) async {
    emit(GroupLoading());
    final result = await groupRepo.createGroup(
      groupName: groupName,
      members: members,
      imageUrl: imageUrl,
    );
    result.fold(
      (failure) => emit(GroupError(failure.message)),
      (success) =>
          emit(GroupCreated("Group '$groupName' created successfully")),
    );
  }
}
