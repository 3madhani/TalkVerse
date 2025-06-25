import 'package:flutter/material.dart';

import 'widgets/settings_screen_body.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = 'settings-screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const SettingsScreenBody(),
    );
  }
}
