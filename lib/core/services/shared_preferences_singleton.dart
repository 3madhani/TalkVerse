import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _instance;

  // Keys
  static const String _keyIsDarkMode = 'isDarkMode';
  static const String _keyPrimaryColor = 'primaryColor';

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  /// Set dark mode (true = dark mode)
  static Future<void> setDarkMode(bool isDark) async {
    await _instance.setBool(_keyIsDarkMode, isDark);
  }

  /// Get dark mode value
  static bool isDarkMode() {
    return _instance.getBool(_keyIsDarkMode) ?? false;
  }

  /// Set primary color as hex string (e.g. #2196F3)
  static Future<void> setPrimaryColor(String hexColor) async {
    await _instance.setString(_keyPrimaryColor, hexColor);
  }

  /// Get primary color as hex string
  static String getPrimaryColor() {
    return _instance.getString(_keyPrimaryColor) ?? '#2196F3'; // default color
  }

  // Optional: general methods
  static bool getBool(String key) => _instance.getBool(key) ?? false;
  static String getString(String key) => _instance.getString(key) ?? '';
  static Future<void> setBool(String key, bool value) async =>
      await _instance.setBool(key, value);
  static Future<void> setString(String key, String value) async =>
      await _instance.setString(key, value);
}
