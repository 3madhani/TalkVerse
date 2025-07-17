import 'package:flutter/material.dart';

import '../../../../chats/presentation/views/chat_screen.dart';
import '../../../domain/entities/chat_room_entity.dart';

class ChatCard extends StatelessWidget {
  final ChatRoomEntity chatRoom;

  const ChatCard({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    var of = Theme.of(context);
    return Card(
      elevation: 1,

      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          // Navigate to chat screen
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: chatRoom,
          );
        },
        leading: const CircleAvatar(),
        title: Text(chatRoom.roomName),
        subtitle: Text(
          chatRoom.lastMessage ?? chatRoom.aboutMe,
          style: TextStyle(color: of.textTheme.bodySmall?.color),
        ),
        trailing:
            chatRoom.lastMessage != null
                ? SizedBox(
                  width: 25,
                  height: 25,
                  child: Badge(
                    backgroundColor: of.colorScheme.primary,
                    label: const Text(
                      '33',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                : Text(
                  chatRoom.formatDateAndTime(),
                  style: TextStyle(color: of.textTheme.bodyMedium?.color),
                ),
      ),
    );
  }
}
