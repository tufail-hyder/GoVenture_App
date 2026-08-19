import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class CategoryGridItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  CategoryGridItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
}

class CategoryGrid extends StatelessWidget {
  final List<CategoryGridItem> items;

  const CategoryGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm + 2),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: item.onTap,
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(AppSizes.sm + 2),
              decoration: BoxDecoration(
                color: item.bgColor,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: AppSizes.iconMd),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.subtitle,
                          style: TextStyle(
                              color: AppColors.textSecondaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
                      Icon(Icons.chevron_right, size: 22, color: AppColors.textSecondaryLight),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}