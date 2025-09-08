import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/user_cubit/user_data_cubit.dart';
import '../../../../core/services/get_it_services.dart';
import 'widgets/settings_screen_body.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = 'settings-screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<UserDataCubit>()..loadSingleUserData(
                userId: FirebaseAuth.instance.currentUser!.uid,
              ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const SettingsScreenBody(),
      ),
    );
  }
}
