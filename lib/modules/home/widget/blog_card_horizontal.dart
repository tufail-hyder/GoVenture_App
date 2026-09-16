import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/blog_model.dart';
import '../../../core/constants/app_colors.dart';

class BlogCardHorizontal extends StatelessWidget {
  final BlogModel blog;
  final VoidCallback onTap;

  const BlogCardHorizontal({
    super.key,
    required this.blog,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.surfaceDark : Colors.white;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final publishedDate = blog.publishedAt != null ? DateFormat('MMM d, yyyy').format(blog.publishedAt!) : '';
    final readTimeLabel = blog.readTimeMinutes > 0 ? '${blog.readTimeMinutes} min read' : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
              child: blog.coverImage.isNotEmpty
                  ? Image.network(
                blog.coverImage,
                fit: BoxFit.cover,
                cacheWidth: (320 * MediaQuery.of(context).devicePixelRatio).round(),
                errorBuilder: (_, __, ___) => Container(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  child: Icon(Icons.image_not_supported_outlined, color: secondaryColor),
                ),
              )
                  : Container(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                child: Icon(Icons.image_outlined, color: secondaryColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: titleColor, height: 1.25),
                  ),
                  const SizedBox(height: 6),
                  if (publishedDate.isNotEmpty)
                    Text(publishedDate, style: TextStyle(fontSize: 11, color: secondaryColor, fontWeight: FontWeight.w500)),
                  if (readTimeLabel.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(readTimeLabel, style: TextStyle(fontSize: 11, color: secondaryColor, fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}