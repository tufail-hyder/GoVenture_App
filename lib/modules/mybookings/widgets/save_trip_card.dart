import 'package:flutter/material.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class SavedTripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const SavedTripCard({
    super.key,
    required this.trip,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppSizes.radiusLg)),
              child: SizedBox(
                width: 110,
                height: 120,
                child: trip.coverImage.isNotEmpty
                    ? Image.network(trip.coverImage, fit: BoxFit.cover)
                    : Container(color: Colors.grey.shade300),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm + 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(trip.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: textPrimary)),
                        ),
                        GestureDetector(
                          onTap: onRemove,
                          child: const Icon(Icons.favorite_rounded, size: 20, color: AppColors.favoriteRed),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: textSecondary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(trip.location, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11.5, color: textSecondary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12, color: textSecondary),
                        const SizedBox(width: 4),
                        Text('${trip.duration} Days / $nights Nights', style: TextStyle(fontSize: 11.5, color: textSecondary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text('PKR ${trip.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary)),
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