import 'dart:convert';
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

  // Generic access
  static bool getBool(String key) => _instance.getBool(key) ?? false;
  static String getString(String key) => _instance.getString(key) ?? '';
  static Future<void> setBool(String key, bool value) async =>
      await _instance.setBool(key, value);
  static Future<void> setString(String key, String value) async =>
      await _instance.setString(key, value);
  static Future<void> remove(String key) async => await _instance.remove(key);

  // ===== Extended Cache Management =====

  /// Get JSON-decoded map from a cached string value
  static Map<String, dynamic> getJsonMap(String key) {
    final raw = getString(key);
    if (raw.isEmpty) return {};
    try {
      return jsonDecode(raw);
    } catch (_) {
      return {};
    }
  }

  /// Save JSON-encodable map to string
  static Future<void> setJsonMap(String key, Map<String, dynamic> map) async {
    await setString(key, jsonEncode(map));
  }

  /// Remove an entry from a cached JSON map and save it back
  static Future<void> removeFromJsonMap(
    String key,
    String mapKeyToRemove,
  ) async {
    final map = getJsonMap(key);
    map.remove(mapKeyToRemove);
    await setJsonMap(key, map);
  }
}
