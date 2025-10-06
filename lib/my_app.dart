import 'package:chitchat/core/helpers/on_generate_routes.dart';
import 'package:chitchat/features/auth/presentation/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/firebase_messaging_service.dart';
import 'features/home/presentation/manager/theme_view_model.dart';
import 'features/home/presentation/views/home_layout.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class TalkVerse extends StatelessWidget {
  const TalkVerse({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeViewModel.selectedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeViewModel.selectedColor,
          brightness: Brightness.dark,
        ),
      ),
      onGenerateRoute: onGenerateRoutes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasData) {
            return const HomeLayout();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
