import 'package:chitchat/features/auth/presentation/manager/auth_provider.dart';
import 'package:chitchat/features/settings/presentation/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/get_it_services.dart';
import '../../../auth/domain/repo/auth_repo.dart';
import '../../../auth/presentation/views/login_screen.dart';
import 'widgets/dark_tile.dart';
import 'widgets/navigation_tile.dart';
import 'widgets/profile_tile.dart';
import 'widgets/sign_out_tile.dart';
import 'widgets/theme_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = 'settings-screen';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(authRepo: getIt<AuthRepo>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Padding(
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
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              const ThemeTile(),
              const DarkModeTile(),
              Consumer<AuthProvider>(
                builder:
                    (context, authProvider, child) => GestureDetector(
                      onTap: () {
                        authProvider.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const SignOutTile(),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
