import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/colors/colors.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../home/presentation/views/home_layout.dart';
import '../../manager/auth_cubit/auth_cubit.dart';
import '../forget_password_screen.dart';
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

class VerifyEmailScreen extends StatelessWidget {
  static const routeName = 'verify_email_screen';
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please check your inbox and verify your email.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().checkEmailVerification();
              },
              child: const Text('I Verified My Email'),
            ),
          ],
        ),
      ),
    );
  }
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
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is AuthVerificationRequired) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'verify_email_screen', // create a screen for this
                  (_) => false,
                );
              } else if (state is AuthSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeLayout.routeName,
                  (_) => false,
                );
              } else if (state is AuthWithSocialSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeLayout.routeName,
                  (_) => false,
                );
              }
            },

            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state is AuthLoading;

                return Form(
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
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  ForgetPasswordScreen.routeName,
                                ),
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const CircularProgressIndicator()
                          : CustomElevatedButton(
                            onPressed: () => _handleLogin(context),
                            label: 'Login',
                          ),
                      const SizedBox(height: 16),
                      isLoading
                          ? const CircularProgressIndicator()
                          : CustomSecondaryButton(
                            onPressed: () => _handleSignUp(context),
                          ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialButton(
                            icon: Assets.imagesGoogleIcons,
                            onTap: () {
                              context.read<AuthCubit>().signInWithGoogle();
                            },
                          ),
                          const SizedBox(width: 30),
                          SocialButton(
                            icon: Assets.imagesFacebookIcons,
                            onTap:
                                () =>
                                    context
                                        .read<AuthCubit>()
                                        .signInWithFacebook(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
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

  void _handleLogin(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }

  void _handleSignUp(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }
}
