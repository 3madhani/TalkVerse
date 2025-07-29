import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/presentation/views/widgets/custom_text_field.dart';

class CreateGroupSection extends StatelessWidget {
  final TextEditingController groupNameController;
  const CreateGroupSection({super.key, required this.groupNameController});

  @override
  Widget build(BuildContext context) {
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
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_a_photo),
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
