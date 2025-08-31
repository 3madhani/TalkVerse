import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../../../core/services/get_it_services.dart';
import '../../../../../core/widgets/app_snack_bar.dart';

class ProfilePicture extends StatelessWidget {
  final String profilePictureUrl;
  const ProfilePicture({super.key, required this.profilePictureUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Container(
              width: 130,
              height: 130,
              color: colorScheme.primaryContainer,
              child:
                  _isValidUrl(profilePictureUrl)
                      ? CachedNetworkImage(
                        imageUrl: profilePictureUrl,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const Center(
                              child: SizedBox(
                                width: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Icon(
                              Icons.error,
                              color: colorScheme.error,
                              size: 40,
                            ),
                      )
                      : Icon(
                        Iconsax.user,
                        size: 60,
                        color: colorScheme.onPrimaryContainer,
                      ),
            ),
          ),

          /// Edit button
          Positioned(
            bottom: -2,
            right: -2,
            child: IconButton.filled(
              onPressed: () => _pickAndUploadImage(context),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                padding: const EdgeInsets.all(8),
                shape: CircleBorder(
                  side: BorderSide(color: colorScheme.surface, width: 2),
                ),
              ),
              icon: const Icon(Iconsax.edit, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == "http" || uri.scheme == "https");
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        if (context.mounted) {
          // Upload image to backend or Firebase Storage
          getIt<UserDataCubit>().uploadProfileImage(File(image.path)).then((
            imageUrl,
          ) {
            if (imageUrl != null) {
              getIt<UserDataCubit>().updateUserData(
                data: {'photoUrl': imageUrl},
              );
            }
          });
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showWarning(context, "Failed to pick image: $e");
      }
    }
  }
}
