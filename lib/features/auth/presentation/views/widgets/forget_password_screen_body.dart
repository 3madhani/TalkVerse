import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/services/get_it_services.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../manager/auth_cubit/auth_cubit.dart';
import '../../manager/auth_cubit/auth_state.dart';
import 'custom_elevated_button.dart';
import 'custom_text_field.dart';

class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({super.key});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listener: (context, state) {
        if (state is AuthFailure) {
          AppSnackBar.showError(context, state.message);
        } else if (state is SendResetPasswordSuccess) {
          AppSnackBar.showSuccess(
            context,
            'Reset password email sent!, check your email and Log in.',
          );
          Navigator.pop(context);
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              label: 'Email',
              prefixIcon: Iconsax.direct,
              controller: emailController,
            ),

            const SizedBox(height: 16),
            CustomElevatedButton(
              onPressed: () {
                validateForm();
              },
              label: 'Send Email',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    formKey.currentState?.dispose();
    getIt<AuthCubit>().close();
    super.dispose();
  }

  void validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      getIt<AuthCubit>().sendResetPasswordEmail(email: emailController.text);
    }
  }
}
