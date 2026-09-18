import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Persists small user preferences (theme mode, language, currency) to
/// local storage via GetStorage, so choices survive app restarts.
class PreferencesService {
  static final _box = GetStorage();

  static const _keyThemeMode = 'pref_theme_mode';
  static const _keyLanguage = 'pref_language';
  static const _keyCurrency = 'pref_currency';

  static ThemeMode get themeMode {
    switch (_box.read(_keyThemeMode)) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    await _box.write(_keyThemeMode, mode.name);
    Get.changeThemeMode(mode);
  }

  static String get language => _box.read(_keyLanguage) ?? 'English';
  static Future<void> setLanguage(String lang) => _box.write(_keyLanguage, lang);

  static String get currency => _box.read(_keyCurrency) ?? 'PKR';
  static Future<void> setCurrency(String currency) => _box.write(_keyCurrency, currency);
}