import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'widgets/chat_card.dart';

class ChatHomeScreen extends StatelessWidget {
  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
        },
        child: const Icon(Iconsax.message_add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const ChatCard();
          },
        ),
      ),
    );
  }
}
