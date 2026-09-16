import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../tripdetails/models/trip_model.dart';

class UpcomingTripListTile extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const UpcomingTripListTile({
    super.key,
    required this.trip,
    required this.onTap,
  });

  static const _months = [
    '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
  ];

  static const _monthsShort = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ===== Trip ka agla available (future) departure slot dhoondo =====
    final now = DateTime.now();
    final futureSlots = trip.availableDates.where((s) => s.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final nextSlot = futureSlots.isNotEmpty ? futureSlots.first : null;

    final start = nextSlot?.date;
    final duration = trip.duration;
    final nights = duration > 0 ? duration - 1 : 0;
    final end = start != null ? start.add(Duration(days: nights)) : null;
    final remainingSeats = nextSlot?.remainingSeats;

    int? daysLeft;
    if (start != null) {
      final today = DateTime.now();
      final todayMidnight = DateTime(today.year, today.month, today.day);
      final startMidnight = DateTime(start.year, start.month, start.day);
      daysLeft = startMidnight.difference(todayMidnight).inDays;
    }

    final backgroundColor = isDark ? AppColors.surfaceDark : Colors.white;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: dividerColor.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== Date box (day/month) =====
            if (start != null)
              Container(
                width: 44,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${start.day}',
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _months[start.month],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(width: 8),

            // ===== Thumbnail =====
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              child: SizedBox(
                width: 66,
                height: 56,
                child: trip.coverImage.isNotEmpty
                    ? Image.network(
                  trip.coverImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                    child: Icon(Icons.image_not_supported_outlined, color: secondaryColor, size: 20),
                  ),
                )
                    : Container(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  child: Icon(Icons.image_outlined, color: secondaryColor, size: 20),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ===== Middle content: title + meta rows =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 12, color: secondaryColor),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          start != null && end != null
                              ? '${start.day} ${_monthsShort[start.month]} - ${end.day} ${_monthsShort[end.month]}'
                              : '-',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.nightlight_round, size: 11, color: secondaryColor),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$nights Nights',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (remainingSeats != null) ...[
                        const SizedBox(width: 10),
                        Icon(Icons.event_seat_outlined, size: 12, color: secondaryColor),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '$remainingSeats Seats Left',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ===== Right: Days Left pill + chevron =====
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 76),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (daysLeft != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          daysLeft > 0 ? '$daysLeft Days Left' : 'Ongoing',
                          maxLines: 1,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}