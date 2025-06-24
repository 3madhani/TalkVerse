import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'login_screen.dart';
import 'widgets/setup_profile_body.dart';

class SetupProfile extends StatelessWidget {
  static const routeName = 'setup-profile';

  final Map<String, String> userData;

  const SetupProfile({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Iconsax.logout_1),
          ),
        ],
      ),
      body: SetupProfileBody(userData: userData),
    );
  }
}
