import 'package:flutter/material.dart';

import '../../../../chats/presentation/views/chat_screen.dart';
import '../../../domain/entities/chat_room_entity.dart';

class ChatCard extends StatelessWidget {
  final ChatRoomEntity chatRoom;

  const ChatCard({super.key, required this.chatRoom});

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
        title: Text(chatRoom.id),
        subtitle: Text(
          chatRoom.lastMessage,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        trailing: const Badge(
          padding: EdgeInsets.all(6),
          largeSize: 30,
          label: Text('1'),
        ),
      ),
    );
  }
}
