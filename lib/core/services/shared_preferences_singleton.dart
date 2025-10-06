import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _instance;

  // Keys
  static const String _keyIsDarkMode = 'isDarkMode';
  static const String _keyPrimaryColor = 'primaryColor';

  // Generic access
  static bool getBool(String key) => _instance.getBool(key) ?? false;
  static int? getInt(String key) => _instance.getInt(key);

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

  /// Get primary color as hex string
  static String getPrimaryColor() {
    return _instance.getString(_keyPrimaryColor) ?? '#2196F3'; // default color
  }

  static String getString(String key) => _instance.getString(key) ?? '';

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _instance = await SharedPreferences.getInstance();
  }

  /// Get dark mode value
  static bool isDarkMode() {
    return _instance.getBool(_keyIsDarkMode) ?? false;
  }

  static Future<void> remove(String key) async => await _instance.remove(key);

  /// Remove an entry from a cached JSON map and save it back
  static Future<void> removeFromJsonMap(
    String key,
    String mapKeyToRemove,
  ) async {
    final map = getJsonMap(key);
    map.remove(mapKeyToRemove);
    await setJsonMap(key, map);
  }

  /// ✅ Proper reset method (async)
  static Future<void> reset() async {
    _instance = await SharedPreferences.getInstance();
    await _instance.clear();
  }

  static Future<void> setBool(String key, bool value) async =>
      await _instance.setBool(key, value);

  /// Set dark mode (true = dark mode)
  static Future<void> setDarkMode(bool isDark) async {
    await _instance.setBool(_keyIsDarkMode, isDark);
  }

  // ===== Extended Cache Management =====

  static Future<void> setInt(String key, int value) async =>
      await _instance.setInt(key, value);

  /// Save JSON-encodable map to string
  static Future<void> setJsonMap(String key, Map<String, dynamic> map) async {
    await setString(key, jsonEncode(map));
  }

  /// Set primary color as hex string (e.g. #2196F3)
  static Future<void> setPrimaryColor(String hexColor) async {
    await _instance.setString(_keyPrimaryColor, hexColor);
  }

  static Future<void> setString(String key, String value) async =>
      await _instance.setString(key, value);
}
