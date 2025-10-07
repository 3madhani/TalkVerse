import 'package:chitchat/core/services/get_it_services.dart';
import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../manager/chat_room_cubit/chat_room_state.dart';
import '../widgets/body_of_floating_action_button.dart';
import '../widgets/chats_home_screen_body.dart';

class ChatHomeScreen extends StatelessWidget {
  static const routeName = 'chats-home-screen';

  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),

      floatingActionButton: FloatingActionButton(
        heroTag: 'chat-home-fab',
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (ctx) {
              return BlocProvider.value(
                value: getIt<ChatRoomCubit>(),
                child: BlocConsumer<ChatRoomCubit, ChatRoomState>(
                  listener: (context, state) {
                    if (state is ChatRoomSuccess) {
                      Navigator.pop(context);

                      if (state.message.contains("already exists")) {
                        AppSnackBar.showWarning(context, state.message);
                      } else {
                        AppSnackBar.showSuccess(context, state.message);
                      }

                      // refresh rooms after creating
                      context.read<ChatRoomCubit>().listenToUserChatRooms();
                    } else if (state is ChatRoomError) {
                      Navigator.pop(context);
                      AppSnackBar.showError(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    return BodyOfBottomSheet(
                      label:
                          state is ChatRoomLoading
                              ? 'Creating...'
                              : 'Create Chat',
                      onAddUser: (ctx, email) {
                        context.read<ChatRoomCubit>().createChatRoom(
                          email: email,
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
        child: const Icon(Iconsax.message_add),
      ),

      body: const ChatsHomeScreenBody(),
    );
  }
}
