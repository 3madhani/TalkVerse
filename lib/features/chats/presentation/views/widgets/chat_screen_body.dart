import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/backend/backend_end_points.dart';
import '../../../../../core/services/get_it_services.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../home/domain/entities/chat_room_entity.dart';
import '../../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../../core/cubits/chat_cubit/chat_message_state.dart';
import 'chat_message_bubble.dart';
import 'send_message_field.dart';
import 'start_message_card.dart';

class ChatScreenBody extends StatelessWidget {
  final ChatRoomEntity chatRoom;

  const ChatScreenBody({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatMessageCubit, ChatMessageState>(
              bloc: getIt<ChatMessageCubit>(),
              listener: (context, state) {
                final cubit = context.read<ChatMessageCubit>();

                if (state is ChatMessageFailure) {
                  AppSnackBar.showError(context, state.message);
                }

                if (state is ChatMessageLoaded) {
                  for (final message in state.messages) {
                    if (!message.isRead && message.senderId != userId) {
                      cubit.markMessageAsReadLocally(message.messageId);
                      cubit.readMessage(
                        collectionPath: BackendEndPoints.chatRooms,
                        chatId: chatRoom.id,
                        isRead: true,
                        messageId: message.messageId,
                      );
                    }
                  }
                }
              },
              builder: (context, state) {
                if (state is ChatMessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatMessageFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is ChatMessageLoaded) {
                  final messages = state.messages;

                  if (messages.isEmpty) {
                    final receiverId = chatRoom.members.firstWhere(
                      (id) => id != userId,
                    );

                    return StartMessageCard(
                      roomName: chatRoom.roomName,
                      onTap: () {
                        if (receiverId.isNotEmpty) {
                          context.read<ChatMessageCubit>().sendMessage(
                            collectionPath: BackendEndPoints.chatRooms,
                            roomId: chatRoom.id,
                            receiverId: receiverId,
                            message:
                                "Hi, ${chatRoom.roomName}!\nLet's start chatting here.",
                          );
                        }
                      },
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSender = message.senderId == userId;

                      return ChatMessageBubble(
                        message: message,
                        isSender: isSender,
                        chatId: chatRoom.id,
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          SendMessageField(chatRoom: chatRoom),
        ],
      ),
    );
  }
}
