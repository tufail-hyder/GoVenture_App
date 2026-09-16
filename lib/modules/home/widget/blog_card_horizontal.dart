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
    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    // DATE
    final publishedDate = blog.publishedAt != null ? DateFormat('MMM d, yyyy').format(blog.publishedAt!) : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 355,
        height: 120,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dividerColor.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.055,),
              blurRadius: 14,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // BLOG IMAGE
            SizedBox(
              width: 145,
              height: double.infinity,
              child: blog.coverImage.isNotEmpty ? Image.network(blog.coverImage, fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace,) {
                  return Container(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    child: Icon(Icons.image_not_supported_outlined, color: secondaryColor, size: 28,),
                  );
                },
              )
                  : Container(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                child: Icon(Icons.image_outlined, color: secondaryColor, size: 28,
                ),
              ),
            ),

            // RIGHT CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 6,),
                child: Row(
                  children: [
                    // TEXT CONTENT
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2,),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CATEGORY
                            if (blog.category.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4,),
                                decoration: BoxDecoration(
                                  color: AppColors.accentBlueLight,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(blog.category, maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600,),
                                ),
                              ),

                            const SizedBox(height: 6),

                            // TITLE
                            Text(blog.title, maxLines: 3, overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(color: titleColor, fontSize: 16, fontWeight: FontWeight.w600, height: 1.18,),
                            ),
                            const Spacer(),
                            // DATE
                            if (publishedDate.isNotEmpty)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.calendar_today_outlined, size: 13, color: secondaryColor,fontWeight: FontWeight.w600,),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(publishedDate, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: secondaryColor, fontSize: 12, fontWeight: FontWeight.w600,),
                                    ),
                                  ),
                                ],
                              ),

                            const SizedBox(height: 4),

                            // READ TIME
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.schedule_outlined, size: 13, color: secondaryColor,fontWeight: FontWeight.w600),
                                const SizedBox(width: 4),
                                Text('5 min read',
                                  style: TextStyle(color: secondaryColor, fontSize: 12, fontWeight: FontWeight.w600,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ARROW
                    const SizedBox(width: 5),
                     const Icon(Icons.chevron_right_rounded, size: 32, color: AppColors.primary,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}