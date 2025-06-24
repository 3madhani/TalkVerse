import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/get_it_services.dart';
import '../../domain/repo/auth_repo.dart';
import '../manager/auth_cubit/auth_cubit.dart';
import 'widgets/login_screen_body.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login-screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(getIt<AuthRepo>()),
      child: Scaffold(appBar: AppBar(), body: const LoginScreenBody()),
    );
  }
}
