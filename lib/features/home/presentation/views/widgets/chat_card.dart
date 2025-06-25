import 'package:flutter/material.dart';

import '../../../../chats/presentation/views/chat_screen.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          // Navigate to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatScreen()),
          );
        },
        leading: const CircleAvatar(),
        title: const Text('Chat'),
        subtitle: const Text('Last message from Chat '),
        trailing: const Badge(
          padding: EdgeInsets.all(6),
          largeSize: 30,
          label: Text('1'),
        ),
      ),
    );
  }
}
