import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'widgets/body_of_floating_action_button.dart';
import 'widgets/chat_home_screen_body.dart';

class ChatHomeScreen extends StatelessWidget {
  static const routeName = 'chats-home-screen';

  const ChatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return const BodyOfFloatingActionButton();
            },
          );
        },
        child: const Icon(Iconsax.message_add),
      ),
      body: const ChatHomeScreenBody(),
    );
  }
}
