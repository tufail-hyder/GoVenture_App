import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../mybookings/screens/my_bookings_screen.dart';
import '../../tripdetails/models/trip_model.dart';
import '../controllers/booking_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../root/root_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final TripModel trip;
  final String bookingId;
  const BookingConfirmationScreen({super.key, required this.trip, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;
    final date = controller.draft.value.selectedDate;
    final endDate = date?.add(Duration(days: trip.duration > 0 ? trip.duration - 1 : 0));

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.xxl),
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
            ),
            const SizedBox(height: AppSizes.md),
            Text('Booking Confirmed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary)),
            const SizedBox(height: 4),
            Text('Your trip has been successfully booked.', style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(height: AppSizes.lg),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ConfirmRow(label: 'Booking ID', value: 'GV-${bookingId.substring(0, bookingId.length > 8 ? 8 : bookingId.length).toUpperCase()}', textPrimary: textPrimary, textSecondary: textSecondary),
                    const Divider(),
                    _ConfirmRow(icon: Icons.landscape_rounded, value: trip.title, textPrimary: textPrimary, textSecondary: textSecondary),
                    if (date != null && endDate != null)
                      _ConfirmRow(icon: Icons.calendar_today_rounded, value: '${DateFormat('d MMM').format(date)} - ${DateFormat('d MMM yyyy').format(endDate)}', textPrimary: textPrimary, textSecondary: textSecondary),
                    _ConfirmRow(icon: Icons.access_time_rounded, value: '${trip.duration} Days · $nights Nights', textPrimary: textPrimary, textSecondary: textSecondary),
                    _ConfirmRow(icon: Icons.groups_rounded, value: '${controller.draft.value.totalTravelers} Participants', textPrimary: textPrimary, textSecondary: textSecondary),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary)),
                        Text('PKR ${controller.grandTotal.toStringAsFixed(0)}',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text('We have sent the booking details to your email.', style: TextStyle(fontSize: 12, color: textSecondary)),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAll(() => const MyBookingsScreen());
                      },
                      child: const Text('View Booking'),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Get.offAll(() => const RootScreen()),
                      child: const Text('Back to Home'),
                    ),
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

class _ConfirmRow extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String value;
  final Color textPrimary;
  final Color textSecondary;
  const _ConfirmRow({this.label, this.icon, required this.value, required this.textPrimary, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 15, color: AppColors.primary), const SizedBox(width: 6)],
          if (label != null) Text('$label: ', style: TextStyle(fontSize: 13, color: textSecondary)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary))),
        ],
      ),
    );
  }
}