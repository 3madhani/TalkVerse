import 'package:chitchat/features/settings/presentation/views/widgets/profile_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../manager/profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = 'profile-screen';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const ProfileScreenBody(),
      ),
    );
  }
}
