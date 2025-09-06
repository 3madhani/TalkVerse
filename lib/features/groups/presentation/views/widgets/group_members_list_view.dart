import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/features/groups/presentation/cubits/group_cubit/group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/entities/group_entity.dart';

class GroupMembersListView extends StatefulWidget {
  final GroupEntity group;
  final List<UserEntity> members;
  final bool isAdmin;

  const GroupMembersListView({
    super.key,
    required this.group,
    required this.members,
    required this.isAdmin,
  });

  @override
  State<GroupMembersListView> createState() => _GroupMembersListViewState();
}

class _GroupMembersListViewState extends State<GroupMembersListView> {
  late List<UserEntity> _members;
  late List<String> _groupMembers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _groupMembers.length,
      itemBuilder: (context, index) {
        final member = _members[index];
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
                widget.group.admins.contains(member.uId)
                    ? const Text('Admin', style: TextStyle(color: Colors.green))
                    : const Text(
                      'Member',
                      style: TextStyle(color: Colors.grey),
                    ),
            trailing:
                widget.isAdmin && !widget.group.admins.contains(member.uId)
                    ? IconButton(
                      icon: const Icon(Iconsax.trash, color: Colors.red),
                      onPressed: () async {
                        await getIt<GroupCubit>().removeMember(
                          groupId: widget.group.id,
                          userId: member.uId,
                        );

                        // Update local state so UI refreshes
                        setState(() {
                          _members.removeAt(index);
                          _groupMembers.removeAt(index);
                        });
                      },
                    )
                    : null,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _members = List<UserEntity>.from(widget.members);
    _groupMembers = List<String>.from(widget.group.members);
  }
}
