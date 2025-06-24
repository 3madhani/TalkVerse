import 'package:chitchat/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/get_it_services.dart';
import '../../../auth/domain/repo/auth_repo.dart';
import 'widgets/settings_screen_body.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = 'settings-screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(getIt<AuthRepo>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const SettingsScreenBody(),
      ),
    );
  }
}
