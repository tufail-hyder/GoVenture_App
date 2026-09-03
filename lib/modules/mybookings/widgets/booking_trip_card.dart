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
  final VoidCallback onVoucher;
  final VoidCallback onManage;
  final VoidCallback onContactSupport;

  const BookingTripCard({
    super.key,
    required this.booking,
    required this.relativeLabel,
    required this.onTap,
    required this.onItinerary,
    required this.onVoucher,
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

    final endDate = booking.selectedDate.add(Duration(days: booking.tripDuration > 0 ? booking.tripDuration - 1 : 0));
    final nights = booking.tripDuration > 0 ? booking.tripDuration - 1 : 0;
    final participantsLabel = _participantsLabel();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Image + badge + Booking ID =====
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
                  child: SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: booking.tripCoverImage.isNotEmpty
                        ? Image.network(booking.tripCoverImage, fit: BoxFit.cover)
                        : Container(color: Colors.grey.shade300),
                  ),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
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
                  _buildStatusPill(),
                  const SizedBox(height: AppSizes.sm),
                  Divider(color: divider, height: 1),
                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ActionButton(icon: Icons.description_outlined, label: 'Itinerary', onTap: onItinerary),
                      _ActionButton(icon: Icons.receipt_long_outlined, label: 'Voucher', onTap: onVoucher),
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

  Widget _buildStatusPill() {
    final now = DateTime.now();
    String label;
    Color color;
    Color bg;

    if (booking.bookingStatus == 'cancelled') {
      label = 'Cancelled';
      color = AppColors.error;
      bg = AppColors.error.withValues(alpha: 0.1);
    } else if (booking.selectedDate.isBefore(now)) {
      label = 'Completed';
      color = AppColors.accentBlue;
      bg = AppColors.accentBlueLight;
    } else {
      label = 'Upcoming';
      color = AppColors.primary;
      bg = AppColors.primaryLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w700)),
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9, color: textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

