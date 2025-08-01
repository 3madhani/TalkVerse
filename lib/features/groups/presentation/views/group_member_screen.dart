import 'package:chitchat/features/groups/presentation/views/group_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupMemberScreen extends StatelessWidget {
  const GroupMemberScreen({super.key});

  static const routeName = '/group-member-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Members'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                GroupEditScreen.routeName,
              );
            },
            icon: const Icon(Iconsax.user_edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: const Text('Member Name'),
                    subtitle: const Text('Admin'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Iconsax.user_tick),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.trash),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
