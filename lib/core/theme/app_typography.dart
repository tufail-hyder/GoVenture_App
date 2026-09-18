import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color primaryText, Color secondaryText) {
    final display = GoogleFonts.poppinsTextTheme();
    final body = GoogleFonts.interTextTheme();

    return TextTheme(
      // Large headings ("Discover", "Beautiful Places")
      displayLarge: display.displaySmall?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: primaryText,
      ),
      // Section headers ("Popular Destinations")
      headlineSmall: display.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
      // Card titles ("Hunza Valley")
      titleMedium: display.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      // Body copy
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primaryText,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryText,
      ),
      // Labels / captions ("Northern Pakistan", nav labels)
      labelMedium: body.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
      labelSmall: body.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryText,
      ),
    );
  }

  static TextTheme light = textTheme(
    AppColors.textPrimaryLight,
    AppColors.textSecondaryLight,
  );

  static TextTheme dark = textTheme(
    AppColors.textPrimaryDark,
    AppColors.textSecondaryDark,
  );
}