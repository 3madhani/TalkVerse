import 'package:chitchat/core/utils/constants/colors/colors.dart';
import 'package:chitchat/features/auth/presentation/views/forget_password_screen.dart';
import 'package:chitchat/features/auth/presentation/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'setup_profile.dart';
import 'widgets/app_logo.dart';
import 'widgets/custom_elevated_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
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
            Form(
              key: formKey,
              child: Column(
                children: [
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SetupProfile()),
                        (route) => false,
                      );
                    },
                    label: 'Login',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                side: const BorderSide(color: AppColors.primaryColor),
              ),
              child: Center(
                child: Text(
                  'CREATE ACCOUNT',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
