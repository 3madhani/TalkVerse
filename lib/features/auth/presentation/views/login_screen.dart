import 'package:flutter/material.dart';

import 'widgets/app_logo.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppLogo(),
            const SizedBox(height: 12),
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text('To ChitChat', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
