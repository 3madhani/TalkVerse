import 'package:chitchat/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/settings/presentation/view_model/settings_view_model.dart';
import 'firebase_options.dart';

void main() async {
  // ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(
    // wrap app with provider
    ChangeNotifierProvider(
      create: (context) => SettingsViewModel(),
      child: const TalkVerse(),
    ),
  );
}
