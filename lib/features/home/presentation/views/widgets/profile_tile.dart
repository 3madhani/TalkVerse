import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/features/settings/presentation/views/qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/cubits/user_cubit/user_data_cubit.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder:
          (context, state) => ListTile(
            minVerticalPadding: 40,
            title: Text(
              state is UserDataLoaded
                  ? state.user.name!
                  : state is UserDataLoading
                  ? 'Loading...'
                  : 'User Name',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                width: 60,
                height: 60,
                child: CachedNetworkImage(
                  imageUrl: state is UserDataLoaded ? state.user.photoUrl! : '',

                  fit: BoxFit.contain,
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
            trailing: IconButton(
              icon: const Icon(Iconsax.scan_barcode),
              onPressed: () {
                // Navigate to QR code screen
                Navigator.pushNamed(context, QrCodeScreen.routeName);
              },
            ),
          ),
    );
  }
}
