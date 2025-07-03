import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/services/get_it_services.dart';
import '../../../home/domain/entities/chat_room_entity.dart';
import '../../domain/repo/chat_message_repo.dart';
import '../manager/chat_cubit/chat_message_cubit.dart';
import 'widgets/chat_screen_body.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = 'chat-screen';
  final ChatRoomEntity chatRoom;
  const ChatScreen({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              ChatMessageCubit(getIt<ChatMessageRepo>())
                ..fetchMessages(chatRoom.id),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(chatRoom.roomName),
              Text(
                'Last seen at 10:00 am',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Iconsax.trash)),
            IconButton(onPressed: () {}, icon: const Icon(Iconsax.copy)),
            IconButton(onPressed: () {}, icon: const Icon(Iconsax.more)),
          ],
        ),
        body: ChatScreenBody(chatRoom: chatRoom),
      ),
    );
  }
}
