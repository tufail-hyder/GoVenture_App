import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../models/review_model.dart';
import 'section_title.dart';

class TripReviewsSection extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final List<ReviewModel> reviews;
  final String? currentUserId;
  final VoidCallback onWriteReview;
  final void Function(ReviewModel review) onEditReview;
  final VoidCallback onViewAll;

  const TripReviewsSection({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
    required this.currentUserId,
    required this.onWriteReview,
    required this.onEditReview,
    required this.onViewAll,
  });

  static const int _previewCount = 3;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    ReviewModel? myReview;
    if (currentUserId != null) {
      for (final r in reviews) {
        if (r.userId == currentUserId) {
          myReview = r;
          break;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TripSectionTitle('Reviews'),
            if (reviewCount > 0)
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                  const SizedBox(width: 3),
                  Text('${rating.toStringAsFixed(1)} ($reviewCount)',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textPrimary)),
                ],
              ),
          ],
        ),
        const SizedBox(height: AppSizes.sm + 2),

        // ---- Write / Edit entry point — always visible ----
        InkWell(
          onTap: myReview != null ? () => onEditReview(myReview!) : onWriteReview,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(myReview != null ? Icons.edit_rounded : Icons.rate_review_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  myReview != null ? 'Edit Your Review' : 'Write a Review',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.sm + 2),

        if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
            child: Text(
              'No reviews yet — be the first to share your experience!',
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
          )
        else ...[
          ...reviews.take(_previewCount).map((r) => ReviewTile(
            review: r,
            isOwner: r.userId == currentUserId,
            onEdit: () => onEditReview(r),
          )),
          if (reviews.length > _previewCount) ...[
            const SizedBox(height: AppSizes.sm),
            Center(
              child: TextButton(
                onPressed: onViewAll,
                child: Text(
                  'Show all ${reviews.length} reviews',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
          ],
        ],
      ],
    );
  }
}

class ReviewTile extends StatelessWidget {
  final ReviewModel review;
  final bool isOwner;
  final VoidCallback? onEdit;

  const ReviewTile({super.key, required this.review, this.isOwner = false, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.sm + 2),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: review.userPhoto.isNotEmpty ? NetworkImage(review.userPhoto) : null,
                child: review.userPhoto.isEmpty
                    ? Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))
                    : null,
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(review.userName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textPrimary)),
                        ),
                        if (isOwner) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                            ),
                            child: const Text('You', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ),
                        ],
                      ],
                    ),
                    if (review.createdAt != null)
                      Text(DateFormat('MMM d, yyyy').format(review.createdAt!),
                          style: TextStyle(fontSize: 11.5, color: textSecondary)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  i < review.rating.round() ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 14,
                  color: Colors.amber,
                )),
              ),
              // ---- Only the review's own author sees an edit affordance ----
              if (isOwner && onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_rounded, size: 16, color: textSecondary),
                  padding: const EdgeInsets.only(left: 6),
                  constraints: const BoxConstraints(),
                  splashRadius: 16,
                ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: AppSizes.sm),
            Text(review.comment, style: TextStyle(fontSize: 13, color: textPrimary, height: 1.4)),
          ],
        ],
      ),
    );
  }
}