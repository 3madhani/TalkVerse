import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactsTextField extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String)? onChanged;
  const ContactsTextField({
    super.key,
    required this.searchController,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      autofocus: true,
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        prefixIcon: const Icon(Iconsax.search_normal_1, color: Colors.grey),
        filled: true,
        fillColor:
            Theme.of(context).scaffoldBackgroundColor, // Light background
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
