import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../domain/entities/chat_room_entity.dart';
import '../../manager/chat_room_cubit/chat_room_state.dart';
import 'chat_card.dart';

class ChatHomeScreenBody extends StatelessWidget {
  const ChatHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatRoomCubit, ChatRoomState>(
      listener: (context, state) {
        if (state is ChatRoomError) {
          AppSnackBar.showError(context, state.message);
        } else if (state is ChatRoomSuccess) {
          if (state.message.contains("already exists")) {
            AppSnackBar.showWarning(context, state.message);
          } else {
            AppSnackBar.showSuccess(context, state.message);
          }
        }
      },
      builder: (context, state) {
        final chatRoomCubit = context.read<ChatRoomCubit>();
        final cachedRooms = chatRoomCubit.chatRoomsCache;

        // Skeleton loading
        if (state is ChatRoomLoading && cachedRooms.isEmpty) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ChatCard(
                    chatRoom: ChatRoomEntity(
                      id: '',
                      roomName: 'Loading...',
                      aboutMe: '',
                      createdAt: '',
                      lastMessageTime: '',
                      members: [],
                      lastMessage: null,
                    ),
                  ),
                );
              },
            ),
          );
        }

        final chatRooms =
            state is ChatRoomListLoaded ? state.chatRooms : cachedRooms;

        if (chatRooms.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final room = chatRooms[index];

              return ChatCard(chatRoom: room);
            },
          );
        }

        // Empty state
        return const Center(
          child: Text(
            'Welcome to Chat Home, start chatting!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
