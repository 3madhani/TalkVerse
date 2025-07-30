import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/shared_preferences_singleton.dart';
import '../../../domain/entities/group_entity.dart';
import '../../../domain/repos/group_repo.dart';

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

  /// Create a new group
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
      emit(const GroupSuccess("Group created successfully"));
    });
  }

  /// Delete a group
  Future<void> deleteGroup(String groupId) async {
    try {
      await groupRepo.deleteGroup(groupId);
      groupsCache.removeWhere((group) => group.id == groupId);
      await _cacheGroups(groupsCache);
      emit(GroupLoaded(List.from(groupsCache)));
      emit(const GroupSuccess("Group deleted successfully"));
    } catch (e) {
      emit(GroupError("Failed to delete group: $e"));
    }
  }

  /// Listen to all groups for the user
  void listenToGroups() {
    if (groupsCache.isNotEmpty) {
      emit(GroupLoaded(groupsCache));
    } else {
      emit(GroupLoading());
    }

    _subscription?.cancel();
    _subscription = groupRepo.getGroups().listen((either) async {
      either.fold((failure) => emit(GroupError(failure.message)), (
        groups,
      ) async {
        groupsCache = _sortGroups(groups);
        await _cacheGroups(groupsCache);
        emit(GroupLoaded(groupsCache));
      });
    });
  }

  /// Load cached groups from SharedPreferences
  Future<void> loadCachedGroups() async {
    final cachedJson = Prefs.getString(_groupsCacheKey);
    if (cachedJson.isEmpty) {
      groupsCache = [];
      emit(GroupLoaded(groupsCache));
      return;
    }

    try {
      final List<dynamic> decoded = jsonDecode(cachedJson);
      final cachedGroups =
          decoded
              .map((e) => GroupEntity.fromJson(e))
              .cast<GroupEntity>()
              .toList();

      groupsCache = _sortGroups(cachedGroups);
      emit(GroupLoaded(groupsCache));
    } catch (_) {
      emit(const GroupError('Failed to load cached groups'));
    }
  }

  /// Save groups to local cache
  Future<void> _cacheGroups(List<GroupEntity> groups) async {
    final jsonList = groups.map((e) => e.toJson()).toList();
    await Prefs.setString(_groupsCacheKey, jsonEncode(jsonList));
  }

  /// Sort groups by last message time or creation date
  List<GroupEntity> _sortGroups(List<GroupEntity> groups) {
    DateTime parse(String? value, String fallback) {
      try {
        value ??= fallback;
        return RegExp(r'^\d+\$').hasMatch(value)
            ? DateTime.fromMillisecondsSinceEpoch(int.parse(value))
            : DateTime.parse(value);
      } catch (_) {
        return DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    groups.sort((a, b) {
      final aTime = parse(a.lastMessageTime, a.createdAt);
      final bTime = parse(b.lastMessageTime, b.createdAt);
      return bTime.compareTo(aTime);
    });

    return groups;
  }
}
