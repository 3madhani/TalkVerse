import 'package:chitchat/core/constants/colors/colors.dart';
import 'package:chitchat/features/home/presentation/views/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_assets.dart';
import '../../manager/auth_provider.dart';
import '../forget_password_screen.dart';
import '../setup_profile.dart';
import 'app_logo.dart';
import 'custom_elevated_button.dart';
import 'custom_secondary_button.dart';
import 'custom_text_field.dart';
import 'social_button.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
          Row(
            children: [
              Text('To ', style: Theme.of(context).textTheme.bodyLarge),
              Text(
                'TalkVerse',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Consumer<AuthProvider>(
            builder:
                (context, authProvider, child) => Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Column(
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
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const ForgetPasswordScreen(),
                                      ),
                                    ),
                                child: Text(
                                  'Forgot Password?',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          authProvider.isLoading
                              ? const CircularProgressIndicator()
                              : CustomElevatedButton(
                                onPressed: () => _handleLogin(authProvider),
                                label: 'Login',
                              ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomSecondaryButton(
                        onPressed: () {
                          // Optional: go to Sign Up or other flow
                        },
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialButton(
                            icon: Assets.imagesGoogleIcons,
                            onTap: () async {
                              final authProvider = context.read<AuthProvider>();

                              await authProvider.signInWithGoogle();

                              if (!mounted) {
                                return;
                              }

                              if (authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage!),
                                  ),
                                );
                              } else if (authProvider.isLoggedIn) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomeLayout(),
                                  ),
                                  (_) => false,
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 30),
                          SocialButton(
                            icon: Assets.imagesFacebookIcons,
                            onTap: () async {
                              await authProvider.signInWithFacebook();
                              if (authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage!),
                                  ),
                                );
                              } else if (authProvider.isLoggedIn) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SetupProfile(),
                                  ),
                                  (_) => false,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    if (!formKey.currentState!.validate()) return;

    await authProvider.signIn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (authProvider.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
    } else if (authProvider.isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SetupProfile()),
        (_) => false,
      );
    }
  }
}
