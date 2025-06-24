import 'package:chitchat/core/helpers/on_generate_routes.dart';
import 'package:chitchat/core/services/firebase_auth_service.dart';
import 'package:chitchat/features/auth/presentation/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/home/presentation/views/home_layout.dart';
import 'features/settings/presentation/view_model/settings_view_model.dart';

class TalkVerse extends StatelessWidget {
  const TalkVerse({super.key});

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
          onGenerateRoute: onGenerateRoutes,
          initialRoute:
              FirebaseAuthService().isLoggedIn()
                  ? HomeLayout.routeName
                  : LoginScreen.routeName,
        );
      },
    );
  }
}
