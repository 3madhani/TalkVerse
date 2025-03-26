import 'package:chitchat/features/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'widgets/app_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
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
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text('To ChitChat', style: Theme.of(context).textTheme.bodyLarge),
            CustomTextField(
              label: 'Email',
              prefixIcon: Iconsax.direct,
              controller: emailController,
            ),
            CustomTextField(
              obscureText: true,
              label: 'Password',
              prefixIcon: Iconsax.password_check,
              controller: passwordController,
            ),
          ],
        ),
      ),
    );
  }
}
