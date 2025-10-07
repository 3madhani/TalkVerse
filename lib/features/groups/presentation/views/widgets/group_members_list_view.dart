import 'package:chitchat/features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/entities/group_entity.dart';

class GroupMembersListView extends StatefulWidget {
  final GroupEntity group;
  final List<UserEntity> members;

  const GroupMembersListView({
    super.key,
    required this.group,
    required this.members,
  });

  @override
  State<GroupMembersListView> createState() => _GroupMembersListViewState();
}

class _GroupMembersListViewState extends State<GroupMembersListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.members.length,
      itemBuilder: (context, index) {
        final member = widget.members[index];
        final isMemberAdmin = widget.group.admins.contains(member.uId);

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  member.photoUrl != null
                      ? NetworkImage(member.photoUrl!)
                      : null,
              child: member.photoUrl == null ? const Icon(Iconsax.user) : null,
            ),
            title: Text(member.name ?? 'No Name'),
            subtitle:
                isMemberAdmin
                    ? const Text('Admin', style: TextStyle(color: Colors.green))
                    : const Text(
                      'Member',
                      style: TextStyle(color: Colors.grey),
                    ),
            trailing:
                widget.group.admins.contains(
                      FirebaseAuth.instance.currentUser?.uid,
                    )
                    ? _buildAdminActions(member, isMemberAdmin, index)
                    : null,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.members.sort((a, b) => a.name!.compareTo(b.name!));
  }

  Widget _buildAdminActions(UserEntity member, bool isGroupAdmin, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Toggle admin status button
        if (!isGroupAdmin)
          IconButton(
            onPressed: () {
              context.read<GroupCubit>().addAdmin(
                groupId: widget.group.id,
                userId: member.uId,
              );
            },
            icon: const Icon(Iconsax.user_add, color: Colors.green),
            tooltip: 'Make Admin',
          )
        else
          IconButton(
            onPressed: () {
              context.read<GroupCubit>().removeAdmin(
                groupId: widget.group.id,
                userId: member.uId,
              );
            },
            icon: const Icon(Iconsax.user_remove, color: Colors.orange),
            tooltip: 'Remove Admin',
          ),

        // Remove member button
        IconButton(
          icon: const Icon(Iconsax.trash, color: Colors.red),
          tooltip: 'Remove Member',
          onPressed: () => _showRemoveMemberDialog(member, isGroupAdmin, index),
        ),
      ],
    );
  }

  Future<void> _showRemoveMemberDialog(
    UserEntity member,
    bool isGroupAdmin,
    int index,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Remove Member'),
            content: Text(
              'Are you sure you want to remove ${member.name ?? 'this member'} from the group?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Remove'),
              ),
            ],
          ),
    );

    if (confirmed == true && mounted) {
      // Remove admin privileges if member is an admin
      if (isGroupAdmin) {
        context.read<GroupCubit>().removeAdmin(
          groupId: widget.group.id,
          userId: member.uId,
        );
      }

      // Remove member from group
      await context.read<GroupCubit>().removeMember(
        groupId: widget.group.id,
        userId: member.uId,
      );

      // Update local state
      if (mounted) {
        setState(() {
          widget.members.removeAt(index);
        });
      }
    }
  }
}
