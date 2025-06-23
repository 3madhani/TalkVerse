import 'package:chitchat/features/auth/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/settings/presentation/view_model/settings_view_model.dart';

class ChitChat extends StatelessWidget {
  const ChitChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, settingsViewModel, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode:
              settingsViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: settingsViewModel.selectedColor,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: settingsViewModel.selectedColor,
              brightness: Brightness.dark,
            ),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}
