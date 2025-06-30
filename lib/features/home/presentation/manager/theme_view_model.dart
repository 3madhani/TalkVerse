import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  static const _colorKey = 'selectedColor';
  static const _darkModeKey = 'isDarkMode';

  Color _selectedColor = Colors.blue;
  bool _isDarkMode = false;

  ThemeViewModel() {
    _loadPrefs();
  }
  bool get isDarkMode => _isDarkMode;

  Color get selectedColor => _selectedColor;

  void changeThemeColor(Color color) {
    _selectedColor = color;
    _saveColorToPrefs(color);
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    _saveDarkModeToPrefs(value);
    notifyListeners();
  }

  // Helper: Convert Color to Hex
  String _colorToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  // Helper: Convert Hex to Color
  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) hexColor = 'FF$hexColor';
    return Color(int.parse(hexColor, radix: 16));
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final colorHex = prefs.getString(_colorKey) ?? '#FF2196F3'; // Default blue
    _selectedColor = _hexToColor(colorHex);

    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveColorToPrefs(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_colorKey, _colorToHex(color));
  }

  Future<void> _saveDarkModeToPrefs(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }
}
