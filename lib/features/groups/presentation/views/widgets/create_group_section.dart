import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/presentation/views/widgets/custom_text_field.dart';

class CreateGroupSection extends StatelessWidget {
  final TextEditingController groupNameController;
  const CreateGroupSection({super.key, required this.groupNameController});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(radius: 40),
              Positioned(
                bottom: -10,
                right: -10,
                child: IconButton.filled(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                    padding: const EdgeInsets.all(8),
                    shape: CircleBorder(
                      side: BorderSide(color: colorScheme.surface, width: 2),
                    ),
                  ),
                  icon: const Icon(Iconsax.camera, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            label: 'Group Name',
            prefixIcon: Iconsax.user_octagon,
            controller: groupNameController,
          ),
        ),
      ],
    );
  }
}
