import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../models/review_model.dart';
import '../widgets/trip_reviews_section.dart';

class AllReviewsScreen extends StatelessWidget {
  const AllReviewsScreen({
    super.key,
    required this.rating,
    required this.reviews,
    required this.currentUserId,
    required this.onEditReview,
  });

  final double rating;
  final List<ReviewModel> reviews;
  final String? currentUserId;
  final void Function(ReviewModel review) onEditReview;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reviews', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textPrimary)),
            const SizedBox(width: 8),
            const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
            const SizedBox(width: 2),
            Text('${rating.toStringAsFixed(1)} (${reviews.length})',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary)),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          final isOwner = review.userId == currentUserId;
          return ReviewTile(
            review: review,
            isOwner: isOwner,
            onEdit: isOwner ? () => onEditReview(review) : null,
          );
        },
      ),
    );
  }
}