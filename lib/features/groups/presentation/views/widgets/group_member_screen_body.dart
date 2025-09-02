import 'package:flutter/material.dart';

import '../../../../auth/domain/entities/user_entity.dart';
import '../../../domain/entities/group_entity.dart';
import 'group_members_list_view.dart';

class GroupMemberScreenBody extends StatelessWidget {
  final GroupEntity group;

  final List<UserEntity> members;
  final bool isAdmin;
  const GroupMemberScreenBody({
    super.key,
    required this.group,
    required this.members,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: GroupMembersListView(
              group: group,
              members: members,
              isAdmin: isAdmin,
            ),
          ),
        ],
      ),
    );
  }
}
