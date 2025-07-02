import 'package:chitchat/features/home/domain/entities/chat_room_entity.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../core/widgets/text_field_message.dart';

class ChatScreen extends StatelessWidget {
  static const String routeName = 'chat-screen';
  final ChatRoomEntity chatRoom;
  const ChatScreen({super.key, required this.chatRoom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Column(
          children: [
            Expanded(
              //   child: ListView.builder(
              //     padding: const EdgeInsets.all(0),
              //     reverse: true,
              //     itemCount: 10,
              //     itemBuilder: (context, index) => MessageBubble(index: index),
              //   ),
              child: Center(
                child: InkResponse(
                  onTap: () {},
                  child: Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '👋',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineLarge!.copyWith(fontSize: 100),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hi, My Friend',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const TextfieldMessage(),
          ],
        ),
      ),
    );
  }
}
