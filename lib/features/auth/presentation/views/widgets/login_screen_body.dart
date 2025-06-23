import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../forget_password_screen.dart';
import '../setup_profile.dart';
import 'app_logo.dart';
import 'custom_elevated_button.dart';
import 'custom_secondary_button.dart';
import 'custom_text_field.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          Text('To TalkVerse', style: Theme.of(context).textTheme.bodyLarge),
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
                    if (formKey.currentState!.validate()) {
                      // Perform login action here
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetupProfile(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  label: 'Login',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const CustomSecondaryButton(),
        ],
      ),
    );
  }
}
