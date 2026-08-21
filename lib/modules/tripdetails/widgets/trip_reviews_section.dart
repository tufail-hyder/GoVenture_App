import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/review_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'section_title.dart';

class TripReviewsSection extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final List<ReviewModel> reviews;

  const TripReviewsSection({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TripSectionTitle('Reviews'),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                const SizedBox(width: 3),
                Text('${rating.toStringAsFixed(1)} ($reviewCount)',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm + 2),
        ...reviews.take(5).map((r) => _ReviewTile(review: r)),
        if (reviews.length > 5)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('View all ${reviews.length} reviews',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
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
                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    if (review.createdAt != null)
                      Text(DateFormat('MMM d, yyyy').format(review.createdAt!),
                          style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondaryLight)),
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
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: AppSizes.sm),
            Text(review.comment, style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimaryLight, height: 1.4)),
          ],
        ],
      ),
    );
  }
}