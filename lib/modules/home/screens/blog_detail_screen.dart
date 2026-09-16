import 'package:flutter/material.dart';
import '../models/blog_model.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogModel blog;
  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: blog.coverImage.isNotEmpty
                  ? Image.network(
                blog.coverImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade400),
              )
                  : Container(color: Colors.grey.shade400),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (blog.category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(blog.category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ),
                  const SizedBox(height: 10),
                  Text(blog.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: scheme.onSurface)),
                  const SizedBox(height: 8),
                  if (blog.readTimeMinutes > 0)
                    Text('${blog.readTimeMinutes} min read', style: TextStyle(fontSize: 13, color: scheme.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 16),
                  if (blog.introText.isNotEmpty)
                    Text(blog.introText, style: TextStyle(fontSize: 15, height: 1.7, color: scheme.onSurface)),

                  // ===== Sections =====
                  ...blog.sections.map((s) => Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.heading, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: scheme.onSurface)),
                        const SizedBox(height: 8),
                        if (s.image.isNotEmpty) ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                            child: Image.network(
                              s.image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(height: 180, color: Colors.grey.shade300),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(s.description, style: TextStyle(fontSize: 15, height: 1.7, color: scheme.onSurface)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}