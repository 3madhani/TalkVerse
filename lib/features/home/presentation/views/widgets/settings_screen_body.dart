import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../../../settings/presentation/views/profile_screen.dart';
import 'dark_tile.dart';
import 'navigation_tile.dart';
import 'profile_tile.dart';
import 'sign_out_tile.dart';
import 'theme_tile.dart';

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const ProfileTile(),
          NavigationTile(
            title: 'Profile',
            icon: Iconsax.user,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const ThemeTile(),
          const DarkModeTile(),
          GestureDetector(
            onTap: () {
              context.read<AuthCubit>().signOut();
            },
            child: const SignOutTile(),
          ),
        ],
      ),
    );
  }
}
