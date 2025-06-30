import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

import '../manager/auth_cubit/auth_cubit.dart';
import 'widgets/setup_profile_body.dart';

class SetupProfile extends StatelessWidget {
  static const routeName = 'setup-profile';

  const SetupProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            icon: const Icon(Iconsax.logout_1),
          ),
        ],
      ),
      body: const SetupProfileBody(),
    );
  }
}
