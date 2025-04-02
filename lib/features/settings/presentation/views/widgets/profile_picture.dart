import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(radius: 70),
          Positioned(
            bottom: -5,
            right: -5,
            child: IconButton.filled(
              onPressed: () {}, // Implement Profile Image Change
              icon: const Icon(Iconsax.edit),
            ),
          ),
        ],
      ),
    );
  }
}
