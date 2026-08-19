import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/app_theme.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.onFilterTap,
    this.controller,
    this.onChanged,
    this.onTap,
    this.hintText = AppTexts.searchDestinationsHint,
  });

  /// Opens filters (price range, trip type, duration, etc. — wired up once
  /// the backend/filter UI exists).
  final VoidCallback onFilterTap;

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  /// If set, the field becomes read-only and this fires instead — handy
  /// for pushing a dedicated search/results screen instead of typing inline.
  final VoidCallback? onTap;

  final String hintText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary =
    isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
    isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final primary = isDark ? AppColors.primaryDarkMode : AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSizes.md),
          Icon(Icons.search_rounded, color: textSecondary, size: AppSizes.iconMd),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              readOnly: onTap != null,
              style: TextStyle(color: textPrimary),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: textSecondary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          IconButton(
            onPressed: onFilterTap,
            icon: Icon(Icons.tune_rounded, color: primary),
          ),
        ],
      ),
    );
  }
}