import 'package:flutter/material.dart';
import '../../../models/upcoming_booking_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class UpcomingTripListTile extends StatelessWidget {
  final UpcomingBookingModel booking;
  final VoidCallback onTap;

  const UpcomingTripListTile({
    super.key,
    required this.booking,
    required this.onTap,
  });

  static const _months = [
    '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  @override
  Widget build(BuildContext context) {
    final date = booking.travelDate;
    final nights = (booking.duration ?? 0) > 0 ? booking.duration! - 1 : 0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Image + Date Badge Overlay =====
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: booking.tripImage.isNotEmpty
                        ? Image.network(
                      booking.tripImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
                    )
                        : Container(color: Colors.grey.shade300),
                  ),
                ),
                if (date != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 40,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${date.day}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1),
                          ),
                          Text(
                            _months[date.month],
                            style: const TextStyle(fontSize: 9, color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),

            // ===== Title =====
            Text(
              booking.tripTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 2),

            // ===== Duration =====
            if (booking.duration != null)
              Text(
                '${booking.duration} Days · $nights Nights',
                style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
              ),
            const SizedBox(height: 4),

            // ===== Price + Bookmark =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (booking.amount != null)
                  Text(
                    'PKR ${booking.amount!.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                  )
                else
                  const SizedBox.shrink(),
                const Icon(Icons.bookmark_border_rounded, size: 16, color: AppColors.textSecondaryLight),
              ],
            ),
          ],
        ),
      ),
    );
  }
}