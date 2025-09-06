import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
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
  Future<bool> createGroup({
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

    bool isSuccess = false;

    result.fold((failure) => emit(GroupError(failure.message)), (_) {
      emit(const GroupSuccess("Group created successfully"));
      isSuccess = true;
    });

    return isSuccess;
  }

  /// Delete a group
  Future<void> deleteGroup(String groupId) async {
    try {
      await groupRepo.deleteGroup(groupId);
      groupsCache.removeWhere((group) => group.id == groupId);
      await _cacheGroups(groupsCache);

      // Emit GroupLoaded immediately so UI updates
      emit(GroupLoaded(List.from(groupsCache)));

      emit(const GroupSuccess("Group deleted successfully"));
    } catch (e) {
      emit(GroupError("Failed to delete group: $e"));
    }
  }

  /// fetch group members
  void fetchGroupMembers(List<String> memberIds) async {
    emit(GroupLoading());
    try {
      final members = groupRepo.fetchMembers(memberIds);
      emit(GroupMembersLoaded(members));
    } catch (e) {
      emit(GroupError("Failed to fetch group members: $e"));
    }
  }

  /// Listen to user's groups
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
        emit(GroupLoaded(List.from(groupsCache)));
      });
    });
  }

  /// Load cached groups
  Future<void> loadCachedGroups() async {
    final cachedJson = Prefs.getString(_groupsCacheKey);
    if (cachedJson.isEmpty) {
      groupsCache = [];
      emit(GroupLoaded(groupsCache)); // ✅ Show empty list if no cache
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

  Future<void> removeMember({
    required String groupId,
    required String userId,
  }) async {
    try {
      await groupRepo.deleteMember(groupId, userId);
      emit(const GroupSuccess("Member removed successfully"));
    } catch (e) {
      emit(GroupError("Failed to remove member: $e"));
    }
  }

  /// Update a group
  Future<void> updateGroup({
    required String groupId,
    required String groupName,
    required List<String> members,
  }) async {
    try {
      await groupRepo.updateGroup(groupId, groupName, members);
      groupsCache =
          groupsCache.map((group) {
            if (group.id == groupId) {
              return group.copyWith(name: groupName, members: members);
            }
            return group;
          }).toList();
      await _cacheGroups(groupsCache);

      // Emit GroupLoaded immediately so UI updates
      emit(GroupLoaded(List.from(groupsCache)));
    } catch (e) {
      emit(GroupError("Failed to update group: $e"));
      return;
    }
  }

  /// Cache groups
  Future<void> _cacheGroups(List<GroupEntity> groups) async {
    final jsonList = groups.map((e) => e.toJson()).toList();
    await Prefs.setString(_groupsCacheKey, jsonEncode(jsonList));
  }

  /// Sort by last message time or creation date
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
