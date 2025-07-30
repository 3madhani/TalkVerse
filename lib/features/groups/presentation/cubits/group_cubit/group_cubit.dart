import 'dart:async';
import 'dart:convert';

import 'package:chitchat/features/groups/domain/repos/group_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/shared_preferences_singleton.dart';
import '../../../data/models/group_model.dart';
import '../../../domain/entities/group_entity.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  static const _groupsCacheKey = "cached_groups";
  final GroupRepo groupRepo;
  StreamSubscription? _groupsSubscription;

  GroupCubit(this.groupRepo) : super(GroupInitial());

  @override
  Future<void> close() {
    _groupsSubscription?.cancel();
    return super.close();
  }

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
      (_) => emit(GroupCreated("Group '$groupName' created successfully")),
    );
  }

  Future<void> deleteGroup(String groupId) async {
    emit(GroupLoading());
    final result = await groupRepo.deleteGroup(groupId);
    result.fold(
      (failure) => emit(GroupError(failure.message)),
      (_) => emit(const GroupDeleted("Group deleted successfully")),
    );
  }

  void startListeningToGroups() {
    // Emit cache first
    final cachedData = Prefs.getString(_groupsCacheKey);
    if (cachedData.isNotEmpty) {
      try {
        final List decoded = jsonDecode(cachedData);
        final cachedGroups =
            decoded
                .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
                .toList();
        emit(GroupLoaded(cachedGroups));
      } catch (_) {}
    }

    _groupsSubscription?.cancel();
    _groupsSubscription = groupRepo.getGroups().listen((either) {
      either.fold((failure) => emit(GroupError(failure.message)), (groups) {
        emit(GroupLoaded(groups));
        final toCache = groups.map((g) => (g as GroupModel).toJson()).toList();
        Prefs.setString(_groupsCacheKey, jsonEncode(toCache));
      });
    });
  }
}
