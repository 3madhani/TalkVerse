import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../home/domain/entities/chat_room_entity.dart';
import '../manager/chat_cubit/chat_message_cubit.dart';
import '../manager/chat_cubit/chat_message_state.dart';
import 'widgets/chat_screen_body.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'chat-screen';
  final ChatRoomEntity chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatMessageCubit, ChatMessageState>(
      builder: (context, state) {
        final isSelecting =
            state is ChatMessageLoaded && state.selectedMessageIds.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title:
                isSelecting
                    ? Text('${state.selectedMessageIds.length} selected')
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.chatRoom.roomName),
                        Text(
                          'Last seen at 10:00 am',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
            actions:
                isSelecting
                    ? [
                      IconButton(
                        icon: const Icon(Iconsax.trash),
                        onPressed: () {
                          context.read<ChatMessageCubit>().deleteMessage(
                            receiverId: widget.chatRoom.members.firstWhere(
                              (id) =>
                                  id != FirebaseAuth.instance.currentUser?.uid,
                            ),
                            chatId: widget.chatRoom.id,
                            messageId: state.selectedMessageIds.toList(),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.copy),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: state.messages
                                  .where(
                                    (msg) => state.selectedMessageIds.contains(
                                      msg.messageId,
                                    ),
                                  )
                                  .map((msg) => msg.message)
                                  .join('\n'),
                            ),
                          );
                          context.read<ChatMessageCubit>().clearSelection();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.read<ChatMessageCubit>().clearSelection();
                        },
                      ),
                    ]
                    : [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Iconsax.more),
                      ),
                    ],
          ),
          body: ChatScreenBody(chatRoom: widget.chatRoom),
        );
      },
    );
  }

  @override
  void initState() {
    context.read<ChatMessageCubit>().fetchMessages(widget.chatRoom.id);
    super.initState();
  }
}
