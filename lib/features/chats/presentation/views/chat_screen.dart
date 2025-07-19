import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/images_repo/images_repo.dart';
import '../../../../core/services/get_it_services.dart';
import '../../../home/domain/entities/chat_room_entity.dart';
import '../../domain/repo/chat_message_repo.dart';
import '../manager/chat_cubit/chat_message_cubit.dart';
import '../manager/chat_cubit/chat_message_state.dart';
import 'widgets/chat_screen_body.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = 'chat-screen';
  final ChatRoomEntity chatRoom;

  const ChatScreen({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              ChatMessageCubit(getIt<ChatMessageRepo>(), getIt<ImagesRepo>())
                ..fetchMessages(chatRoom.id),
      child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
        builder: (context, state) {
          final isSelecting =
              state is ChatMessageLoaded && state.selectedMessageIds.isNotEmpty;

          return Scaffold(
            appBar: AppBar(
              title:
                  isSelecting
                      ? Text('${state.selectedMessageIds.length} selected')
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(chatRoom.roomName),
                          Text(
                            'Last seen at 10:00 am',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
              actions:
                  isSelecting
                      ? [
                        IconButton(
                          icon: const Icon(Iconsax.trash),
                          onPressed: () {
                            context.read<ChatMessageCubit>().deleteMessage(
                              chatId: chatRoom.id,
                              messageId: state.selectedMessageIds.first,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.forward_square),
                          onPressed: () {
                            // Handle forward
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            context.read<ChatMessageCubit>().clearSelection();
                          },
                        ),
                      ]
                      : [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.more),
                        ),
                      ],
            ),
            body: ChatScreenBody(chatRoom: chatRoom),
          );
        },
      ),
    );
  }
}
