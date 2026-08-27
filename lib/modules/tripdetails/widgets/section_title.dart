import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TripSectionTitle extends StatelessWidget {
  final String title;
  const TripSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Text(
      title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
    );
  }
}