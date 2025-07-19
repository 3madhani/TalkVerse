import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../chats/presentation/manager/chat_cubit/chat_message_cubit.dart';
import '../../../../chats/presentation/manager/chat_cubit/chat_message_state.dart';
import '../../../../chats/presentation/views/chat_screen.dart';
import '../../../domain/entities/chat_room_entity.dart';

class ChatCard extends StatefulWidget {
  final ChatRoomEntity chatRoom;

  const ChatCard({super.key, required this.chatRoom});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocBuilder<ChatMessageCubit, ChatMessageState>(
      builder: (context, state) {
        int unreadCount = 0;

        if (state is ChatMessageLoaded) {
          final messages = state.messages;
          unreadCount =
              messages
                  .where(
                    (message) =>
                        message.isRead == false &&
                        message.senderId != currentUserId,
                  )
                  .length;
        } else if (state is ChatMessageInitial) {
          unreadCount = 0; // Default to 0 while loading
        }

        return Card(
          elevation: 1,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: widget.chatRoom,
              );
            },
            leading: const CircleAvatar(),
            title: Text(widget.chatRoom.roomName),
            subtitle: Text(
              widget.chatRoom.lastMessage ?? widget.chatRoom.aboutMe,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
            trailing:
                unreadCount > 0
                    ? SizedBox(
                      width: 25,
                      height: 25,
                      child: Badge(
                        backgroundColor: theme.colorScheme.primary,
                        label: Text(
                          '$unreadCount',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : Text(
                      widget.chatRoom.formatDateAndTime(),
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatMessageCubit>().fetchMessages(widget.chatRoom.id);
  }
}
