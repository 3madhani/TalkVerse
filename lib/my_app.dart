import 'package:chitchat/features/auth/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';

class ChitChat extends StatelessWidget {
  const ChitChat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: LoginScreen(),
    );
  }
}
