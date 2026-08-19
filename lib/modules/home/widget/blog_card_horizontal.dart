import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/blog_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class BlogCardHorizontal extends StatelessWidget {
  final BlogModel blog;
  final VoidCallback onTap;

  const BlogCardHorizontal({super.key, required this.blog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: SizedBox(
                    height: 90, width: double.infinity,
                    child: blog.coverImage.isNotEmpty
                        ? Image.network(blog.coverImage, fit: BoxFit.cover)
                        : Container(color: Colors.grey.shade300),
                  ),
                ),
                Positioned(
                  top: 6, left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                    child: Text(blog.category, style: const TextStyle(fontSize: 9, color: AppColors.primary)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Text(blog.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
            Text(
              blog.publishedAt != null ? DateFormat('MMM d, yyyy').format(blog.publishedAt!) : '',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}