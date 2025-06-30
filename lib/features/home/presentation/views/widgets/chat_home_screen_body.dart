import 'package:flutter/material.dart';

import 'chat_card.dart';

class ChatHomeScreenBody extends StatelessWidget {
  const ChatHomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ChatCard();
        },
      ),
    );
  }
}
