import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/upcoming_booking_model.dart';
import '../../../core/constants/app_sizes.dart';

class UpcomingBookingCard extends StatelessWidget {
  final UpcomingBookingModel booking;
  final VoidCallback onTap;

  const UpcomingBookingCard({super.key, required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateText = booking.travelDate != null
        ? DateFormat('MMM d, yyyy').format(booking.travelDate!)
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(AppSizes.sm + 4),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: SizedBox(
                width: 56, height: 56,
                child: booking.tripImage.isNotEmpty
                    ? Image.network(booking.tripImage, fit: BoxFit.cover)
                    : Container(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.tripTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium),
                  Text(dateText, style: theme.textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}