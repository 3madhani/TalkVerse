import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../domain/entities/chat_room_entity.dart';
import '../../manager/chat_room_cubit/chat_room_state.dart';
import 'chat_card.dart';

class ChatHomeScreenBody extends StatelessWidget {
  const ChatHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        final chatRoomCubit = context.read<ChatRoomCubit>();
        final cachedRooms = chatRoomCubit.chatRoomsCache;

        // ✅ Case 1: Render actual chat room list from cache or loaded state
        if (state is ChatRoomListLoaded || cachedRooms.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              itemCount: cachedRooms.length,
              itemBuilder: (context, index) {
                return ChatCard(chatRoom: cachedRooms[index]);
              },
            ),
          );
        }

        // ✅ Case 2: Show skeleton only if no data at all
        if (state is ChatRoomLoading && cachedRooms.isEmpty) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ChatCard(
                  chatRoom: ChatRoomEntity(
                    aboutMe: '',
                    roomName: 'Loading...',
                    id: '',
                    lastMessage: '',
                    createdAt: '',
                    members: [],
                    lastMessageTime: '',
                  ),
                );
              },
            ),
          );
        }

        // ✅ Case 3: Fallback UI if there's no data yet
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
