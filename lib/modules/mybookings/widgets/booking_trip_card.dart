import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../booking/models/booking_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class BookingTripCard extends StatelessWidget {
  final BookingModel booking;
  final String relativeLabel;
  final VoidCallback onTap;
  final VoidCallback onItinerary;
  final VoidCallback onManage;
  final VoidCallback onContactSupport;

  const BookingTripCard({
    super.key,
    required this.booking,
    required this.relativeLabel,
    required this.onTap,
    required this.onItinerary,
    required this.onManage,
    required this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    final endDate = booking.endDate;
    final nights = booking.tripDuration > 0 ? booking.tripDuration - 1 : 0;
    final participantsLabel = _participantsLabel();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md + 2),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg + 2),
          border: Border.all(color: divider.withValues(alpha: isDark ? 0.4 : 0.6), width: 1),
          boxShadow: [
            // Soft, wide "floating" shadow so the card lifts off a white page
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.06),
              blurRadius: 24,
              spreadRadius: -4,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Image + gradient overlay + relative badge =====
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg + 2)),
                  child: SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        booking.tripCoverImage.isNotEmpty
                            ? Image.network(booking.tripCoverImage, fit: BoxFit.cover)
                            : Container(color: Colors.grey.shade300),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.18)],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (booking.isUpcoming)
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Text(relativeLabel, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(AppSizes.sm + 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.tripTitle,
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: textPrimary)),
                            if (booking.tripLocation.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded, size: 12, color: textSecondary),
                                  const SizedBox(width: 2),
                                  Text(booking.tripLocation, style: TextStyle(fontSize: 11.5, color: textSecondary)),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Booking ID', style: TextStyle(fontSize: 9.5, color: textSecondary)),
                          Row(
                            children: [
                              Text(_shortBookingId(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textPrimary)),
                              Icon(Icons.chevron_right_rounded, size: 16, color: textSecondary),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),

                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 13, color: textSecondary),
                      const SizedBox(width: 4),
                      Text('${DateFormat('MMM d').format(booking.selectedDate)} - ${DateFormat('MMM d, yyyy').format(endDate)}',
                          style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 13, color: textSecondary),
                      const SizedBox(width: 4),
                      Text('${booking.tripDuration} Days / $nights Nights', style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w600)),
                      const SizedBox(width: AppSizes.md),
                      Icon(Icons.groups_rounded, size: 13, color: textSecondary),
                      const SizedBox(width: 4),
                      Text(participantsLabel, style: TextStyle(fontSize: 12, color: textSecondary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  _buildStatusDot(),
                  const SizedBox(height: AppSizes.sm),
                  Divider(color: divider, height: 1),
                  const SizedBox(height: 8),

                  // ---- Bigger, more tappable action row ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ActionButton(icon: Icons.description_outlined, label: 'Itinerary', onTap: onItinerary),
                      _ActionButton(icon: Icons.edit_calendar_outlined, label: 'Manage Booking', onTap: onManage),
                      _ActionButton(icon: Icons.support_agent_rounded, label: 'Contact Support', onTap: onContactSupport),
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

  Widget _buildStatusDot() {
    String label;
    Color color;

    if (booking.isCancelled) {
      label = 'Cancelled';
      color = AppColors.error;
    } else if (booking.isCompleted) {
      label = 'Completed';
      color = AppColors.accentBlue;
    } else {
      label = 'Upcoming';
      color = AppColors.primary;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }

  String _participantsLabel() {
    final parts = <String>[];
    parts.add('${booking.adults} Adult${booking.adults > 1 ? 's' : ''}');
    if (booking.children > 0) parts.add('${booking.children} Child${booking.children > 1 ? 'ren' : ''}');
    if (booking.infants > 0) parts.add('${booking.infants} Infant${booking.infants > 1 ? 's' : ''}');
    return parts.join(', ');
  }

  String _shortBookingId() {
    final raw = booking.id.length >= 6 ? booking.id.substring(0, 6) : booking.id;
    return 'GV${raw.toUpperCase()}';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textSecondary = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: AppColors.primary),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}