import 'package:chitchat/features/auth/presentation/views/widgets/custom_elevated_button.dart';
import 'package:chitchat/features/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'widgets/chat_card.dart';

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
              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(
                        context,
                      ).viewInsets.bottom, // Avoid keyboard overlap
                  left: 16,
                  right: 16,
                  top: 16,
                ),
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
                    const SizedBox(height: 40),
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
