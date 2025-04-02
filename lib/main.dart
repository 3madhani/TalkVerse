import 'package:chitchat/my_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/home/presentation/view_model/settings_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsViewModel(),
      child: const ChitChat(),
    ),
  );
}
