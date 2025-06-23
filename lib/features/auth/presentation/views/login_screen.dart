import 'package:chitchat/core/services/get_it_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/repo/auth_repo.dart';
import '../manager/auth_provider.dart';
import 'widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String routeName = 'login-screen';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(authRepo: getIt<AuthRepo>()),
      child: Scaffold(appBar: AppBar(), body: const LoginScreenBody()),
    );
  }
}
