import 'package:flutter/material.dart';
import '../../tripdetails/models/trip_model.dart';
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

  String _capitalize(String text) =>
      text.isEmpty ? '' : text[0].toUpperCase() + text.substring(1);

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'adventure':
        return const Color(0xFFE8622C);
      case 'workcation':
        return const Color(0xFF2E7CE8);
      case 'retreat':
        return const Color(0xFF2E9E5B);
      case 'cultural':
        return const Color(0xFFB8860B);
      case 'family':
        return const Color(0xFF7C5FA6);
      case 'honeymoon':
        return const Color(0xFFE0455D);
      case 'seasonal':
        return const Color(0xFF00A9C4);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;
    final hasDiscount = trip.originalPrice != null && trip.originalPrice! > trip.price;
    final discountPercent = hasDiscount
        ? (((trip.originalPrice! - trip.price) / trip.originalPrice!) * 100).round()
        : 0;
    final usdPrice = trip.price / _usdRate;

    final tourModeRaw = trip.tourMode.trim();
    final tourModeLabel = tourModeRaw.isEmpty ? 'Tour' : '${_capitalize(tourModeRaw)} Tour';
    final tourModeIcon = tourModeRaw.toLowerCase() == 'private'
        ? Icons.person_rounded
        : Icons.groups_rounded;

    final typeLabel = _capitalize(trip.type);
    final typeColor = _typeColor(trip.type);

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
            // ---- Cover image: discount, favorite, type chip ----
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: SizedBox(
                    width: 125,
                    height: 160,
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
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 18,
                        color: isFavorite ? AppColors.favoriteRed : Colors.black87,
                      ),
                    ),
                  ),
                ),
                // ---- Trip type chip pinned to bottom-left of image ----
                if (trip.type.isNotEmpty)
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: typeColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(
                        typeLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSizes.sm + 2),

            // ---- Content column: natural height, never overflows ----
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trip.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimaryLight),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 13, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          trip.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: AppColors.textSecondaryLight),
                        ),
                      ),
                    ],
                  ),

                  // ---- Rating + review count ----
                  if (trip.rating > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          trip.reviewCount > 0
                              ? '${trip.rating.toStringAsFixed(1)} (${trip.reviewCount} reviews)'
                              : trip.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 8),

                  // ---- Days / Nights / Tour mode — all same pill style ----
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _PillFeature(icon: Icons.calendar_today_rounded, label: '${trip.duration} Days'),
                      _PillFeature(icon: Icons.nightlight_round_outlined, label: '$nights Nights'),
                      _PillFeature(icon: tourModeIcon, label: tourModeLabel),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ---- Price block: original vs current price, clearly separated ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasDiscount)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'PKR ${trip.originalPrice!.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondaryLight,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors.textSecondaryLight,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '-$discountPercent%',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            if (hasDiscount) const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  'PKR ',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                                Text(
                                  trip.price.toStringAsFixed(0),
                                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.primary),
                                ),
                              ],
                            ),
                            Text(
                              '≈ \$${usdPrice.toStringAsFixed(2)} per person',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.primary),
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
}

class _PillFeature extends StatelessWidget {
  const _PillFeature({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}