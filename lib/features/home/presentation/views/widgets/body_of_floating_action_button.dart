import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/presentation/views/widgets/custom_elevated_button.dart';
import '../../../../auth/presentation/views/widgets/custom_text_field.dart';

class BodyOfFloatingActionButton extends StatelessWidget {
  const BodyOfFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Avoid keyboard overlap
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
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            label: 'Create Chat',
            onPressed: () {},
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
