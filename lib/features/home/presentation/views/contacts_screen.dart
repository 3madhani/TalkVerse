import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../auth/presentation/views/widgets/custom_elevated_button.dart';
import '../../../auth/presentation/views/widgets/custom_text_field.dart';
import 'widgets/contact_card.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
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
                      label: 'Add Contact',
                      onPressed: () {},
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Iconsax.user_add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return const ContactCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
