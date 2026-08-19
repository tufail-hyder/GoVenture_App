import 'package:flutter/material.dart';
import '../../../models/blog_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class BlogPreviewCard extends StatelessWidget {
  final BlogModel blog;
  final VoidCallback onTap;

  const BlogPreviewCard({super.key, required this.blog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: SizedBox(
                width: 90, height: 70,
                child: blog.coverImage.isNotEmpty
                    ? Image.network(blog.coverImage, fit: BoxFit.cover)
                    : Container(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlueLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Text(blog.category,
                        style: const TextStyle(color: AppColors.accentBlue, fontSize: 11)),
                  ),
                  const SizedBox(height: 4),
                  Text(blog.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}