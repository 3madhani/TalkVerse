import 'package:chitchat/features/auth/presentation/views/widgets/custom_elevated_button.dart';
import 'package:chitchat/features/auth/presentation/views/widgets/custom_text_field.dart';
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
          showBottomSheet(
            context: context,
            builder: (_) {
              return Container(
                padding: const EdgeInsets.all(16),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter Friend Email',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Iconsax.scan_barcode),
                        ),
                      ],
                    ),
                    CustomTextField(
                      label: 'Email',
                      prefixIcon: Iconsax.direct,
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 16),
                    CustomElevatedButton(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      label: 'Create Chat',
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
          );
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
