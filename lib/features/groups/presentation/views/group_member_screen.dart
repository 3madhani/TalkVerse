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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            text: group.name,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: ' Members',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
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
