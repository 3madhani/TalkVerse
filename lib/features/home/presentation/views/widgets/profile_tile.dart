import 'package:chitchat/features/settings/presentation/views/qr_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/cubits/user_cubit/user_data_cubit.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 40,
      title: BlocBuilder<UserDataCubit, UserDataState>(
        builder: (context, state) {
          if (state is UserDataLoaded) {
            print("Error loading user data: ${state.user.name}"); // Debug print
          }
          return Text(
            state is UserDataLoaded
                ? state.user.name!
                : state is UserDataLoading
                ? 'Loading...'
                : 'User Name',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        },
      ),
      leading: const CircleAvatar(radius: 30),
      trailing: IconButton(
        icon: const Icon(Iconsax.scan_barcode),
        onPressed: () {
          // Navigate to QR code screen
          Navigator.pushNamed(context, QrCodeScreen.routeName);
        },
      ),
    );
  }
}
