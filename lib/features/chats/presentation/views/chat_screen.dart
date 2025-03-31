import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'widgets/message_bubble.dart';
import 'widgets/text_field_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Emad'),
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
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                reverse: true,
                itemCount: 10,
                itemBuilder: (context, index) => MessageBubble(index: index),
              ),
            ),

            const TextfieldMessage(),
          ],
        ),
      ),
    );
  }
}
