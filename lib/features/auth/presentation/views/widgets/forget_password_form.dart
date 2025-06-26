import 'package:flutter/material.dart';

import 'app_logo.dart';
import 'forget_password_screen_body.dart';

class ForgetPasswordScreenBody extends StatelessWidget {
  const ForgetPasswordScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
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
          const ForgetPasswordForm(),
        ],
      ),
    );
  }
}
