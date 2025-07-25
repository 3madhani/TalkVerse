import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

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
  int unreadCount = 0;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocListener<ChatMessageCubit, ChatMessageState>(
      listener: (context, state) {
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
        }
      },
      child: Dismissible(
        key: Key(widget.chatRoom.id),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.red,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (_) async {
          // Optional confirmation dialog
          return await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Chat'),
                      content: const Text(
                        'Are you sure you want to delete this chat?',
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              ) ??
              false;
        },
        onDismissed: (_) async {
          // ✅ Delete the entire chat room and its messages
          await context.read<ChatRoomCubit>().deleteChatRoom(
            widget.chatRoom.id,
          );
        },
        child: Card(
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
            leading: const CircleAvatar(radius: 22, child: Icon(Iconsax.user)),
            title: Text(widget.chatRoom.roomName),
            subtitle: Text(
              widget.chatRoom.lastMessage ?? widget.chatRoom.aboutMe,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
            trailing:
                context.watch<ChatMessageCubit>().state is ChatMessageLoaded &&
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    context.read<ChatMessageCubit>().fetchMessages(widget.chatRoom.id);
    super.initState();
  }
}
