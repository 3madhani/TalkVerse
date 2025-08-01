import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:chitchat/core/widgets/dismissible_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/backend/backend_end_points.dart';
import '../../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../../core/cubits/chat_cubit/chat_message_state.dart';
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
      child: DismissibleCard(
        title: "Delete Chat",
        confirm: true,
        onDismiss: () async {
          await context.read<ChatRoomCubit>().deleteChatRoom(
            widget.chatRoom.id,
          );
        },
        id: widget.chatRoom.id,
        content: "chat",
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
  void initState() {
    context.read<ChatMessageCubit>().fetchMessages(
      widget.chatRoom.id,
      BackendEndPoints.chatRooms,
    );
    super.initState();
  }
}
