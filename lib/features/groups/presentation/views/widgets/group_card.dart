import 'package:chitchat/features/groups/domain/entities/group_entity.dart';
import 'package:chitchat/features/groups/presentation/views/group_chat_screen.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final GroupEntity group;
  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onTap: () {
          // Navigate to chat screen
          Navigator.pushNamed(context, GroupChatScreen.routeName);
        },
        leading: CircleAvatar(child: Text(group.name[0])),
        title: Text(group.name, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(group.lastMessage),
        trailing: const Badge(
          padding: EdgeInsets.all(6),
          largeSize: 30,
          label: Text('5'),
        ),
      ),
    );
  }
}
