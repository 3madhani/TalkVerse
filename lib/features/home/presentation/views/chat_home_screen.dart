import 'package:chitchat/features/home/domain/repo/chat_room_repo.dart';
import 'package:chitchat/features/home/presentation/manager/chat_room_cubit/chat_room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/services/get_it_services.dart';
import 'widgets/body_of_floating_action_button.dart';
import 'widgets/chat_home_screen_body.dart';

class ChatHomeScreen extends StatelessWidget {
  static const routeName = 'chats-home-screen';

  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatRoomCubit(getIt<ChatRoomRepo>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chats')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (bottomSheetContext) {
                return BlocProvider.value(
                  value: bottomSheetContext.read<ChatRoomCubit>(),
                  child: const BodyOfFloatingActionButton(),
                );
              },
            );
          },
          child: const Icon(Iconsax.message_add),
        ),
        body: const ChatHomeScreenBody(),
      ),
    );
  }
}
