import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'section_title.dart';

class TripInclusionsSection extends StatelessWidget {
  final List<String> inclusions;
  final List<String> exclusions;

  const TripInclusionsSection({super.key, required this.inclusions, required this.exclusions});

  @override
  Widget build(BuildContext context) {
    if (inclusions.isEmpty && exclusions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TripSectionTitle('What\'s Included'),
        const SizedBox(height: AppSizes.sm),

        if (inclusions.isNotEmpty)
          ...inclusions.map((item) => _FeatureRow(icon: Icons.check_circle_rounded, color: AppColors.primary, text: item)),

        if (exclusions.isNotEmpty) ...[
          SizedBox(height: inclusions.isNotEmpty ? AppSizes.sm : 0),
          const TripSectionTitle('Not Included'),
          const SizedBox(height: AppSizes.sm),
          ...exclusions.map((item) => _FeatureRow(icon: Icons.cancel_rounded, color: AppColors.error, text: item)),
        ],
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _FeatureRow({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSizes.sm),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: textPrimary, height: 1.4))),
        ],
      ),
    );
  }
}