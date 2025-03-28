import 'package:chitchat/features/home/presentation/views/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'login_screen.dart';
import 'widgets/custom_elevated_button.dart';
import 'widgets/custom_text_field.dart';

class SetupProfile extends StatelessWidget {
  const SetupProfile({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('Welcome,', style: Theme.of(context).textTheme.displayMedium),
            Text('to ChitChat', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text(
              'Please Enter Your Name',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CustomTextField(
              label: 'Name',
              prefixIcon: Iconsax.user,
              controller: emailController,
            ),

            const SizedBox(height: 16),
            CustomElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeLayout()),
                  (route) => false,
                );
              },
              label: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}
