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
      (success) =>
          emit(GroupCreated("Group '$groupName' created successfully")),
    );
  }

  void loadGroups() {
    emit(GroupLoading());

    // ✅ Step 1: Load cached groups immediately
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

    // ✅ Step 2: Listen to real-time Firestore updates
    _groupsSubscription?.cancel();
    _groupsSubscription = groupRepo.getGroups().listen((either) {
      either.fold((failure) => emit(GroupError(failure.message)), (groups) {
        emit(GroupLoaded(groups));

        // ✅ Step 3: Save to cache
        final toCache =
            groups
                .map((g) => (g as GroupModel).toJson())
                .toList(); // Cast to model for toJson()
        Prefs.setString(_groupsCacheKey, jsonEncode(toCache));
      });
    });
  }
}
