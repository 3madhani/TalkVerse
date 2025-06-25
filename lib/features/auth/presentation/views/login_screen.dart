import 'package:flutter/material.dart';

import 'widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login-screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginScreenBody());
  }
}
