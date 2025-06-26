import 'package:chitchat/core/widgets/app_snack_bar.dart';
import 'package:chitchat/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:chitchat/features/auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:chitchat/features/home/presentation/views/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/colors/colors.dart';
import '../../../domain/entities/user_entity.dart';
import 'custom_elevated_button.dart';
import 'custom_text_field.dart';

class SetupProfileBody extends StatefulWidget {
  const SetupProfileBody({super.key});

  @override
  State<SetupProfileBody> createState() => _SetupProfileBodyState();
}

class _AuthListener extends StatelessWidget {
  const _AuthListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackBar.showError(context, state.message);
        } else if (state is SendResetPasswordSuccess) {
          AppSnackBar.showSuccess(context, 'Profile setup successful!');
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeLayout.routeName,
            (route) => false,
          );
        }
      },
      child: const SizedBox(), // Placeholder to satisfy the widget tree
    );
  }
}

class _SetupProfileBodyState extends State<SetupProfileBody> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthCubit, bool>(
      (cubit) => cubit.state is AuthLoading,
    );

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Welcome,',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                'to TalkVerse',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: AppColors.primaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                'Please Enter Your Name',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Name',
                      prefixIcon: Iconsax.user,
                      controller: nameController,
                    ),
                    const SizedBox(height: 16),
                    isLoading
                        ? const CircularProgressIndicator()
                        : CustomElevatedButton(
                          onPressed: _submitProfile,
                          label: 'Continue',
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const _AuthListener(),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    if (!formKey.currentState!.validate()) return;

    final state = context.read<AuthCubit>().state;
    if (state is AuthSuccess) {
      final user = UserEntity(
        name: nameController.text.trim(),
        email: state.user.email,
        uId: state.user.uId,
        photoUrl: '',
      );
      context.read<AuthCubit>().addUserToFirebase(user);
    }
  }
}
