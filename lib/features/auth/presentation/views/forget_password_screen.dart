import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'widgets/app_logo.dart';
import 'widgets/custom_elevated_button.dart';
import 'widgets/custom_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLogo(),
            const SizedBox(height: 20),
            Text(
              'Reset Password',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              'Please enter your email',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            CustomTextField(
              label: 'Email',
              prefixIcon: Iconsax.direct,
              controller: emailController,
            ),

            const SizedBox(height: 16),
            CustomElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              label: 'Send Email',
            ),
          ],
        ),
      ),
    );
  }
}
