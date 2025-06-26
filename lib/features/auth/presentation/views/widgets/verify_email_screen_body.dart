import 'package:chitchat/core/widgets/app_snack_bar.dart';
import 'package:chitchat/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:chitchat/features/auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:chitchat/features/auth/presentation/views/setup_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

class VerifyEmailScreenBody extends StatelessWidget {
  const VerifyEmailScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthCubit, bool>(
      (cubit) => cubit.state is AuthLoading,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'), centerTitle: true),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.verify,
                  size: 90,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 30),
                Text(
                  'Email Verification',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'We’ve sent a verification link to your email address. Please verify it before continuing.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Iconsax.refresh),
                        label: const Text('I Verified My Email'),
                        onPressed: () {
                          context.read<AuthCubit>().checkEmailVerification();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          const _VerifyEmailListener(),
        ],
      ),
    );
  }
}

class _VerifyEmailListener extends StatelessWidget {
  const _VerifyEmailListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackBar.showError(context, state.message);
        } else if (state is SendResetPasswordSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            SetupProfile.routeName,
            (route) => false,
          );
        }
      },
      child: const SizedBox(), // Needed to attach listener to widget tree
    );
  }
}
