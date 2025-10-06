import 'package:chitchat/features/auth/domain/entities/user_entity.dart';
import 'package:chitchat/features/groups/domain/entities/group_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/backend/backend_end_points.dart';
import '../../../../../core/cubits/chat_cubit/chat_message_cubit.dart';
import '../../../../../core/cubits/chat_cubit/chat_message_state.dart';
import '../../../../../core/services/get_it_services.dart';
import '../../../../../core/utils/app_date_time.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../../core/widgets/chat_message_bubble.dart';
import '../../../../../core/widgets/send_message_field.dart';
import '../../../../../core/widgets/start_message_card.dart';

class GroupChatScreenBody extends StatelessWidget {
  final GroupEntity group;
  final List<UserEntity> members;
  const GroupChatScreenBody({
    super.key,
    required this.group,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    members.removeWhere((user) => user.uId == userId);
    print(userId);
    for (var i = 0; i < members.length; i++) {
      print(members[i].uId.toString());
    }
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
                        chatId: group.id,
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
                    final receiverId = group.members.firstWhere(
                      (id) => id != userId,
                    );

                    if (receiverId.isEmpty) return const SizedBox();

                    return StartMessageCard(
                      roomName: group.name,
                      onTap: () {
                        if (receiverId.isNotEmpty) {
                          getIt<ChatMessageCubit>().sendMessage(
                            name: group.name,
                            users: members,
                            collectionPath: BackendEndPoints.groups,
                            roomId: group.id,
                            receiverId: group.id,
                            message:
                                "Hi, ${group.name}!\nLet's start chatting here.",
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
                      String newDate = '';
                      bool isSameDate = false;

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
                          if (!isSameDate) ...[
                            const SizedBox(height: 8),
                            Text(newDate),
                            const SizedBox(height: 8),
                          ],
                          ChatMessageBubble(
                            message: message,
                            isSender: isSender,
                            chatId: group.id,
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
          SendMessageField(group: group, users: members),
        ],
      ),
    );
  }
}
