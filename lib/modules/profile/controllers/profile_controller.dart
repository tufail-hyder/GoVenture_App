import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/preferences_service.dart';

class ProfileController extends GetxController {
  final RxString language = PreferencesService.language.obs;
  final RxString currency = PreferencesService.currency.obs;
  final Rx<ThemeMode> themeMode = PreferencesService.themeMode.obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void setLanguage(String lang) {
    language.value = lang;
    PreferencesService.setLanguage(lang);
  }

  void setCurrency(String value) {
    currency.value = value;
    PreferencesService.setCurrency(value);
  }

  void toggleDarkMode(bool value) {
    final mode = value ? ThemeMode.dark : ThemeMode.light;
    themeMode.value = mode;
    PreferencesService.setThemeMode(mode);
  }
}