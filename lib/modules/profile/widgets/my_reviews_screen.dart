import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../services/reviews_query_service.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('My Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: uid == null
          ? Center(child: Text('Please sign in to see your reviews.', style: TextStyle(color: textSecondary)))
          : FutureBuilder<List<UserReviewEntry>>(
        future: ReviewsQueryService.getUserReviews(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rate_review_outlined, size: 44, color: textSecondary),
                  const SizedBox(height: AppSizes.sm),
                  Text('You haven\'t written any reviews yet.', style: TextStyle(color: textSecondary)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, i) {
              final e = entries[i];
              return Container(
                padding: const EdgeInsets.all(AppSizes.sm + 4),
                decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (e.tripTitle.isNotEmpty)
                      Text(e.tripTitle, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textPrimary)),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < e.review.rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                        size: 15, color: Colors.amber,
                      )),
                    ),
                    if (e.review.comment.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(e.review.comment, style: TextStyle(fontSize: 13, color: textPrimary)),
                    ],
                    if (e.review.createdAt != null) ...[
                      const SizedBox(height: 6),
                      Text(DateFormat('MMM d, yyyy').format(e.review.createdAt!),
                          style: TextStyle(fontSize: 11, color: textSecondary)),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}