import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePicture extends StatelessWidget {
  final String profilePictureUrl;
  const ProfilePicture({super.key, required this.profilePictureUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(70),
            child: Container(
              width: 130,
              height: 130,
              color: colorScheme.primaryContainer,

              child: CachedNetworkImage(
                imageUrl: profilePictureUrl,

                fit: BoxFit.cover,
                placeholder:
                    (context, url) => const SizedBox(
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    ),
                errorWidget:
                    (context, url, error) =>
                        Icon(Icons.error, color: colorScheme.error, size: 40),
              ),
            ),
          ),
          Positioned(
            bottom: -4,
            right: -4,
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
