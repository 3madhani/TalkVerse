import 'package:chitchat/core/cubits/user_cubit/user_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/services/get_it_services.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/universal_chat_card.dart';
import '../manager/chat_room_cubit/chat_room_cubit.dart';
import '../manager/chat_room_cubit/chat_room_state.dart';

class ChatsHomeScreenBody extends StatefulWidget {
  const ChatsHomeScreenBody({super.key});

  @override
  State<ChatsHomeScreenBody> createState() => _ChatsHomeScreenBodyState();
}

class _ChatsHomeScreenBodyState extends State<ChatsHomeScreenBody> {
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
        final chatRoomCubit = getIt<ChatRoomCubit>();
        final cachedRooms = chatRoomCubit.chatRoomsCache;

        // Skeleton loading - use a custom skeleton widget instead of UniversalChatCard
        if (state is ChatRoomLoading && cachedRooms.isEmpty) {
          return Skeletonizer(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 4.0,
                  ),
                  child: Card(
                    elevation: 1,
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 22,
                        child: Icon(Icons.person),
                      ),
                      title: Container(
                        height: 16,
                        width: 150,
                        color: Colors.grey,
                      ),
                      subtitle: Container(
                        height: 14,
                        width: 200,
                        color: Colors.grey,
                      ),
                      trailing: Container(
                        height: 12,
                        width: 50,
                        color: Colors.grey,
                      ),
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: UniversalChatCard(chatRoom: room),
              );
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

  @override
  void initState() {
    super.initState();
    getIt<ChatRoomCubit>().loadCachedChatRooms();
    getIt<ChatRoomCubit>().listenToUserChatRooms();
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (message == 'AppLifecycleState.resumed') {
        getIt<UserDataCubit>().updateUserLastSeen(online: true);
      } else if (message == 'AppLifecycleState.paused' ||
          message == 'AppLifecycleState.inactive') {
        getIt<UserDataCubit>().updateUserLastSeen(online: false);
      }
      return null;
    });
  }
}
