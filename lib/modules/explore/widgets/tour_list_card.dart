import 'package:flutter/material.dart';
import '../../../models/trip_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'card_image.dart';

class TourListCard extends StatelessWidget {
  const TourListCard({
    super.key,
    required this.trip,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final TripModel trip;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  static const double _usdRate = 279.0;

  String _capitalize(String text) => text.isEmpty ? '' : text[0].toUpperCase() + text.substring(1);

  @override
  Widget build(BuildContext context) {
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;
    final hasDiscount = trip.originalPrice != null && trip.originalPrice! > trip.price;
    final discountPercent = hasDiscount ? (((trip.originalPrice! - trip.price) / trip.originalPrice!) * 100).round() : 0;
    final usdPrice = trip.price / _usdRate;

    // ---- Tour mode label + icon straight from Firestore's `tourMode` field ----
    final tourModeRaw = trip.tourMode.trim();
    final tourModeLabel = tourModeRaw.isEmpty ? 'Tour' : '${_capitalize(tourModeRaw)} Tour';
    final tourModeIcon = tourModeRaw.toLowerCase() == 'private' ? Icons.person_rounded : Icons.groups_rounded;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.sm + 4),
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Cover image with discount badge + favorite ----
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: CardImage(coverImage: trip.coverImage),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(
                        '$discountPercent% OFF',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 22,
                        color: isFavorite ? AppColors.favoriteRed : Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSizes.sm + 2),

            // ---- Single column: title, location, days row (+ arrow), type row (+ price) ----
            Expanded(
              child: SizedBox(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimaryLight,),
                        ),
                        const SizedBox(height: 1),
                        Text(trip.location,
                          style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 14, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),

                    // ---- Days / Nights row + arrow at the end ----
                    Row(
                      children: [
                        _FeatureIcon(icon: Icons.calendar_today_rounded, label: '${trip.duration} Days'),
                        SizedBox(width: 6,),
                        _FeatureIcon(icon: Icons.nightlight_round_outlined, label: '$nights Nights'),
                        const Spacer(),
                        const Icon(Icons.chevron_right_rounded, size: 28, color: AppColors.textSecondaryLight),
                      ],
                    ),

                    // ---- Tour type row (from Firestore) + price at the end ----
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: AppSizes.sm + 2,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _FeatureIcon(icon: tourModeIcon, label: tourModeLabel),
                              if (trip.hasTransfers)
                                const _FeatureIcon(icon: Icons.directions_bus_filled_rounded, label: 'Transfers'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (hasDiscount)
                          Text(
                            'PKR ${trip.originalPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondaryLight,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          'PKR ${trip.price.toStringAsFixed(0)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                        Text(
                          '≈ \$${usdPrice.toStringAsFixed(0)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 15, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
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

class _FeatureIcon extends StatelessWidget {
  const _FeatureIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.primary),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
