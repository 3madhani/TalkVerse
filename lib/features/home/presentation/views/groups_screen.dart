import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../groups/presentation/views/create_group_screen.dart';
import 'widgets/group_card.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: 4,
                itemBuilder: (context, index) => const GroupCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
