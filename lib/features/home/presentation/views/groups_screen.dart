import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groups')),
      body: const Center(child: Text('Groups Screen')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action here
        },
        child: const Icon(Iconsax.message_add_1),
      ),
    );
  }
}
