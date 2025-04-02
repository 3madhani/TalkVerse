import 'package:chitchat/features/groups/presentation/views/group_screen.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          // Navigate to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GroupScreen()),
          );
        },
        leading: const CircleAvatar(child: Text('G')),
        title: const Text('Group Name'),
        subtitle: const Text('Last message from Chat '),
        trailing: const Badge(
          padding: EdgeInsets.all(6),
          largeSize: 30,
          label: Text('5'),
        ),
      ),
    );
  }
}
