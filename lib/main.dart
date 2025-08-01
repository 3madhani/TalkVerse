import 'package:chitchat/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/get_it_services.dart';
import 'core/services/shared_preferences_singleton.dart';
import 'core/services/supabase_storage.dart';
import 'features/home/presentation/manager/theme_view_model.dart';
import 'firebase_options.dart';

void main() async {
  // ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Supabase
  await SupabaseStorage.initSupabase();

  // Create Supabase bucket
  // await SupabaseStorage.createBucket("chat-images");
  // Initialize shared preferences
  await Prefs.init();

  // intia;ize getIt
  setupGetIt();

  // run app
  runApp(
    // wrap app with provider
    ChangeNotifierProvider(
      create: (context) => ThemeViewModel(),
      child: const TalkVerse(),
    ),
  );
}
