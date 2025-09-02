import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../domain/entities/group_entity.dart';
import 'widgets/group_edit_screen_body.dart';

class GroupEditScreen extends StatelessWidget {
  static const routeName = '/group-edit-screen';
  final GroupEntity group;

  const GroupEditScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Group')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Done', style: Theme.of(context).textTheme.labelLarge),
        icon: const Icon(Iconsax.tick_circle),
      ),
      body: GroupEditScreenBody(group: group),
    );
  }
}
