// lib/core/widgets/add_user_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/presentation/views/widgets/custom_elevated_button.dart';
import '../../../../auth/presentation/views/widgets/custom_text_field.dart';


typedef AddUserCallback = void Function(BuildContext context, String email);

class BodyOfBottomSheet extends StatefulWidget {
  final String label;
  final AddUserCallback onAddUser;

  const BodyOfBottomSheet({
    super.key,
    required this.label,
    required this.onAddUser,
  });

  @override
  State<BodyOfBottomSheet> createState() => _BodyOfBottomSheetState();
}

class _BodyOfBottomSheetState extends State<BodyOfBottomSheet> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  onPressed: () {
                    // Optional: Handle QR scanner
                  },
                  icon: const Icon(Iconsax.scan_barcode),
                ),
              ],
            ),
            CustomTextField(
              label: 'Email',
              prefixIcon: Iconsax.direct,
              controller: emailController,
            ),
            const SizedBox(height: 18),
            CustomElevatedButton(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              label: widget.label,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  widget.onAddUser(context, emailController.text.trim());
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
