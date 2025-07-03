import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../home/domain/entities/chat_room_entity.dart';
import '../../manager/chat_cubit/chat_message_cubit.dart';
import '../../manager/chat_cubit/chat_message_state.dart';
import 'chat_message_bubble.dart';
import 'send_message_field.dart';
import 'start_message_card.dart';

class ChatScreenBody extends StatelessWidget {
  final ChatRoomEntity chatRoom;

  const ChatScreenBody({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
              builder: (context, state) {
                if (state is ChatMessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatMessageFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is ChatMessageLoaded) {
                  final messages = state.messages;
                  if (messages.isEmpty) {
                    return StartMessageCard(
                      roomName: chatRoom.roomName,
                      onTap: () {
                        final receiverId = chatRoom.members.firstWhere(
                          (id) => id != FirebaseAuth.instance.currentUser?.uid,
                          orElse: () => '',
                        );
                        context.read<ChatMessageCubit>().sendMessage(
                          roomId: chatRoom.id,
                          receiverId: receiverId,
                          message:
                              "Hi, ${chatRoom.roomName}!\nLet's start chatting here.",
                        );
                      },
                    );
                  } else {
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isSender =
                            message.senderId ==
                            FirebaseAuth.instance.currentUser!.uid;
                        return ChatMessageBubble(
                          message: message,
                          isSender: isSender,
                        );
                      },
                    );
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
          SendMessageField(chatRoom: chatRoom),
        ],
      ),
    );
  }
}
