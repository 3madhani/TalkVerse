import 'package:chitchat/core/utils/app_date_time.dart';
import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/backend/backend_end_points.dart';
import '../../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../../core/cubits/chat_cubit/chat_message_state.dart';
import '../../../../../core/services/get_it_services.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../../core/widgets/chat_message_bubble.dart';
import '../../../../../core/widgets/send_message_field.dart';
import '../../../../../core/widgets/start_message_card.dart';
import '../../../../home/domain/entities/chat_room_entity.dart';

class ChatScreenBody extends StatelessWidget {
  final ChatRoomEntity chatRoom;
  final UserEntity user, currentUser;

  const ChatScreenBody({
    super.key,
    required this.chatRoom,
    required this.user,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      child: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatMessageCubit, ChatMessageState>(
              listener: (context, state) {
                final cubit = getIt<ChatMessageCubit>();

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
                if (state is ChatMessageInitial) {
                  return StartMessageCard(
                    roomName: chatRoom.roomName,
                    onTap: () {
                      getIt<ChatMessageCubit>().sendMessage(
                        name: chatRoom.roomName,
                        user: user,
                        collectionPath: BackendEndPoints.chatRooms,
                        roomId: chatRoom.id,
                        receiverId: chatRoom.members.firstWhere(
                          (id) => id != userId,
                        ),
                        message:
                            "Hi, ${currentUser.name}!\nLet's start chatting here.",
                      );
                    },
                  );
                }

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
                          getIt<ChatMessageCubit>().sendMessage(
                            name: chatRoom.roomName,
                            user: user,
                            collectionPath: BackendEndPoints.chatRooms,
                            roomId: chatRoom.id,
                            receiverId: receiverId,
                            message:
                                "Hi, ${currentUser.name}!\nLet's start chatting here.",
                          );
                        }
                      },
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      String newDate = '';
                      bool isSameDate = false;
                      final message = messages[index];
                      final isSender = message.senderId == userId;

                      if ((index == 0 && messages.length == 1) ||
                          index == messages.length - 1) {
                        newDate = AppDateTime.dateTimeFormat(message.createdAt);
                      } else {
                        final DateTime date = AppDateTime.dateFormat(
                          message.createdAt,
                        );

                        final DateTime prevDate = AppDateTime.dateFormat(
                          messages[index + 1].createdAt,
                        );

                        if (date.day != prevDate.day ||
                            date.month != prevDate.month ||
                            date.year != prevDate.year) {
                          isSameDate = false;
                          newDate = AppDateTime.dateTimeFormat(
                            message.createdAt,
                          );
                        } else {
                          isSameDate = true;
                        }
                      }

                      return Column(
                        children: [
                          if (!isSameDate)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(newDate),
                            ),
                          ChatMessageBubble(
                            isGroup: false,
                            message: message,
                            isSender: isSender,
                            chatId: chatRoom.id,
                          ),
                        ],
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          SendMessageField(
            chatRoom: chatRoom,
            user: user,
            currentUser: currentUser,
          ),
        ],
      ),
    );
  }
}
