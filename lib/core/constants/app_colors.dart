import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF165123);
  static const Color primaryLight = Color(0xFFE3EFE6);
  static const Color primaryDarkMode = Color(0xFF4CAF8E);

  // Secondary accents (category chips / tags — used sparingly)
  static const Color accentBlue = Color(0xFF3B6FA6);
  static const Color accentBlueLight = Color(0xFFDCEAFB);
  static const Color accentPurple = Color(0xFF7C5FA6);
  static const Color accentPurpleLight = Color(0xFFEEE7F5);

  // Neutrals — light mode
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1D1E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color dividerLight = Color(0xFFE5E7EB);

  // Neutrals — dark mode
  static const Color backgroundDark = Color(0xFF10141A);
  static const Color surfaceDark = Color(0xFF1A1F1E);
  static const Color textPrimaryDark = Color(0xFFF3F4F4);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color dividerDark = Color(0xFF2A2F2E);

  // Semantic
  static const Color success = Color(0xFF1B4B3F);
  static const Color warning = Color(0xFFB7791F);
  static const Color error = Color(0xFFDC2626);
  static const Color favoriteRed = Color(0xFFE0455D);

  // Shadows
  static const Color cardShadow = Color(0x14000000); // 8% black
}