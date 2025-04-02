import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  Color _selectedColor = Colors.red;
  bool _isDarkMode = false;

  Color get selectedColor => _selectedColor;
  bool get isDarkMode => _isDarkMode;

  void changeThemeColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}