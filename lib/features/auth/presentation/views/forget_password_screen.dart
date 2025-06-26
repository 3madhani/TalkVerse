import 'package:flutter/material.dart';

import 'widgets/forget_password_form.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static const routeName = 'forget-password-screen';

  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ForgetPasswordScreenBody());
  }
}
