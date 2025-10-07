import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool isEnabled;
  final VoidCallback onEdit;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    required this.isEnabled,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: TextField(
          enabled: isEnabled,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        leading: Icon(icon),
        trailing: IconButton(icon: const Icon(Iconsax.edit), onPressed: onEdit),
      ),
    );
  }
}
