import 'package:chitchat/core/widgets/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../../core/constants/colors/colors.dart';
import '../../../../../core/utils/app_assets.dart';
import '../../../../home/presentation/views/home_layout.dart';
import '../../manager/auth_cubit/auth_cubit.dart';
import '../../manager/auth_cubit/auth_state.dart';
import '../forget_password_screen.dart';
import '../verify_email_screen.dart';
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

class _AuthListener extends StatelessWidget {
  const _AuthListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackBar.showError(context, state.message);
        } else if (state is AuthVerificationRequired) {
          Navigator.pushNamed(context, VerifyEmailScreen.routeName);
        } else if (state is AuthSuccess || state is AuthWithSocialSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeLayout.routeName,
            (_) => false,
          );
        }
      },
      child: const SizedBox(), // to satisfy the widget tree
    );
  }
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthCubit, bool>(
      (cubit) => cubit.state is AuthLoading,
    );

    return ModalProgressHUD(
      color: AppColors.primaryColor.withOpacity(0.5),

      inAsyncCall: isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
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
            const SizedBox(height: 24),
            const _AuthListener(), // clean listener
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
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
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(onPressed: _handleLogin, label: 'Login'),
                  const SizedBox(height: 16),
                  CustomSecondaryButton(onPressed: _handleSignUp),
                  const SizedBox(height: 40),
                  const _SocialAuthRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkIfLoggedIn();
  }

  void _handleLogin() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }

  void _handleSignUp() {
    if (formKey.currentState!.validate()) {
      context.read<AuthCubit>().signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }
}

class _SocialAuthRow extends StatelessWidget {
  const _SocialAuthRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          icon: Assets.imagesGoogleIcons,
          onTap: () => context.read<AuthCubit>().signInWithGoogle(),
        ),
        const SizedBox(width: 30),
        SocialButton(
          icon: Assets.imagesFacebookIcons,
          onTap: () => context.read<AuthCubit>().signInWithFacebook(),
        ),
      ],
    );
  }
}
