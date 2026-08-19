import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';

class CategoryChipCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const CategoryChipCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(AppSizes.sm + 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(height: AppSizes.sm),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Text('$count Trips', style: Theme.of(context).textTheme.labelSmall),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}