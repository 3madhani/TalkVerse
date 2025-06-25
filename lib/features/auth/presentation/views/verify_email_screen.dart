import 'package:flutter/material.dart';

import 'widgets/verify_email_screen_body.dart';

class VerifyEmailScreen extends StatelessWidget {
  static const routeName = 'verify_email_screen';

  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Email')),
      body: const VerifyEmailScreenBody(),
    );
  }
}
