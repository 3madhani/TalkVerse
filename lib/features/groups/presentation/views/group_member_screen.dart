import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/group_entity.dart';
import 'group_edit_screen.dart';
import 'widgets/group_member_screen_body.dart';

class GroupMemberScreen extends StatelessWidget {
  static const routeName = '/group-member-screen';
  final GroupEntity group;
  final List<UserEntity> members;

  const GroupMemberScreen({
    super.key,
    required this.group,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = group.admins.contains(
      FirebaseAuth.instance.currentUser!.uid,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  GroupEditScreen.routeName,
                  arguments: group,
                );
              },
              icon: const Icon(Iconsax.user_edit),
            ),
        ],
      ),
      body: GroupMemberScreenBody(
        group: group,
        members: members,
        isAdmin: isAdmin,
      ),
    );
  }
}
