import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'create_group_screen.dart';
import 'widgets/groups_screen_body.dart';

class GroupsScreen extends StatelessWidget {
  static const routeName = 'groups-screen';

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'groups-screen-fab',
        onPressed: () {
          Navigator.pushNamed(context, CreateGroupScreen.routeName);
        },
        child: const Icon(Iconsax.message_add_1),
      ),
      body: const GroupsScreenBody(),
    );
  }
}
