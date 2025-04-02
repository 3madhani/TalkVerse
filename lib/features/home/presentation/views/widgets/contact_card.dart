import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: const Text('Contact Name'),
        subtitle: const Text('Contact Number'),
        trailing: IconButton(
          icon: const Icon(Iconsax.message),
          onPressed: () {},
        ),
      ),
    );
  }
}
