import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignOutTile extends StatelessWidget {
  const SignOutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Sign Out'),
        trailing: const Icon(Iconsax.logout_1),
      ),
    );
  }
}
