import 'package:flutter/material.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class FeaturedTripCard extends StatelessWidget {
  final TripModel trip;
  final String badgeText;
  final Color badgeColor;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const FeaturedTripCard({
    super.key,
    required this.trip,
    required this.badgeText,
    required this.badgeColor,
    required this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Image + Badge + Favorite icon =====
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
                  child: SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: trip.coverImage.isNotEmpty
                        ? Image.network(
                      trip.coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: Colors.grey.shade300),
                    )
                        : Container(color: Colors.grey.shade300),
                  ),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                    child: Text(badgeText, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.favorite_border_rounded, size: 14, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),

            // ===== Text content =====
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.title,
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
                  const SizedBox(height: 4),

                  // Duration + Type row
                  Row(
                    children: [
                      const Icon(Icons.bookmark_border_rounded, size: 14, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 3),
                      Text('${trip.duration} Days · $nights Nights',
                          style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12,fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.directions_walk_rounded, size: 14, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 3),
                      Text(_capitalize(trip.type),
                          style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12,fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: AppSizes.xs),

                  // Price + Rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PKR ${trip.price.toStringAsFixed(0)}',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          const Text('4.8', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          const Text(' (230)', style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) => text.isEmpty ? '' : text[0].toUpperCase() + text.substring(1);
}