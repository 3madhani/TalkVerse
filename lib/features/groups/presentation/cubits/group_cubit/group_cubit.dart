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
  static const _groupsCacheKey = "cachedGroups";
  final GroupRepo groupRepo;
  StreamSubscription? _subscription;

  List<GroupEntity> groupsCache = [];

  GroupCubit(this.groupRepo) : super(GroupInitial());

  @override
  Future<void> close() async {
    await _subscription?.cancel();
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

    result.fold((failure) => emit(GroupError(failure.message)), (_) {
      emit(const GroupCreated("Group created successfully"));
      listenToGroups(); // Refresh the group list
    });
  }

  void listenToGroups() {
    // Emit from cache first
    final cachedJson = Prefs.getString(_groupsCacheKey);
    if (cachedJson.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(cachedJson);
        final cachedGroups =
            decoded
                .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
                .toList();

        groupsCache = cachedGroups;
        emit(GroupLoaded(groupsCache));
      } catch (_) {
        emit(const GroupError("Failed to load cached groups"));
      }
    } else {
      emit(GroupLoading());
    }

    // Listen to live updates
    _subscription?.cancel();
    _subscription = groupRepo.getGroups().listen((either) async {
      either.fold((failure) => emit(GroupError(failure.message)), (
        groups,
      ) async {
        groupsCache = groups;
        await _cacheGroups(groupsCache);
        emit(GroupLoaded(groupsCache));
      });
    });
  }

  Future<void> _cacheGroups(List<GroupEntity> groups) async {
    final jsonList =
        groups
            .map((e) => (e as GroupModel).toJson()) // Convert to JSON
            .toList();
    await Prefs.setString(_groupsCacheKey, jsonEncode(jsonList));
  }
}
