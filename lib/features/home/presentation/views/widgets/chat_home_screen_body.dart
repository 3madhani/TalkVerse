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
        if (state is ChatRoomListLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              itemCount: state.chatRooms.length,
              itemBuilder: (context, index) {
                return ChatCard(chatRoom: state.chatRooms[index]);
              },
            ),
          );
        } else if (state is ChatRoomLoading) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 10,
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
        } else if (state is ChatRoomError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
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
