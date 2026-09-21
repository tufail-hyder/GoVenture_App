import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/tripdetails/screens/pdf_viewer_screen.dart';
import '../../tripdetails/screens/trip_detail_screen.dart';
import '../controllers/my_bookings_controller.dart';
import '../widgets/booking_trip_card.dart';
import '../widgets/contact_support.dart';
import '../widgets/save_trip_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../widgets/manage_booking_sheet.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyBookingsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('My Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: Obx(() {
        final isSavedTab = controller.selectedTab.value == BookingTab.saved;

        if (controller.isLoading.value && !isSavedTab) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSizes.xl),
            children: [
              // ===== Tabs =====
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.sm, AppSizes.sm, AppSizes.sm, 0),
                child: Row(
                  children: [
                    _TabItem(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Upcoming',
                      isSelected: controller.selectedTab.value == BookingTab.upcoming,
                      onTap: () => controller.selectTab(BookingTab.upcoming),
                    ),
                    _TabItem(
                      icon: Icons.done_all_rounded,
                      label: 'Completed',
                      isSelected: controller.selectedTab.value == BookingTab.completed,
                      onTap: () => controller.selectTab(BookingTab.completed),
                    ),
                    _TabItem(
                      icon: Icons.cancel_outlined,
                      label: 'Cancelled',
                      isSelected: controller.selectedTab.value == BookingTab.cancelled,
                      onTap: () => controller.selectTab(BookingTab.cancelled),
                    ),
                    _TabItem(
                      icon: Icons.favorite_border_rounded,
                      label: 'Saved',
                      isSelected: isSavedTab,
                      onTap: () => controller.selectTab(BookingTab.saved),
                    ),
                  ],
                ),
              ),
              const Divider(height: AppSizes.md,thickness: 0.3,),

              // ===== Promo Banner — redesigned =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [AppColors.primary, AppColors.primary.withValues(alpha: 0.78)]
                          : [AppColors.primary, AppColors.primary.withValues(alpha: 0.78)],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg + 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.28),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Decorative faint circle for depth
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Your Adventure Awaits!',
                                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, color: Colors.white)),
                                const SizedBox(height: 4),
                                Text(
                                  'View your upcoming trips, manage bookings and get ready for unforgettable memories.',
                                  style: TextStyle(fontSize: 11.5, color: Colors.white.withValues(alpha: 0.9), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
                            child: const Icon(Icons.hiking_rounded, size: 32, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // ===== Section Header =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + 4),
                child: Text(
                  _sectionTitle(controller.selectedTab.value),
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary),
                ),
              ),
              const SizedBox(height: AppSizes.sm),

              // ===== List: bookings for the 3 booking tabs, trips for Saved =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + 2),
                child: Builder(builder: (context) {
                  if (isSavedTab) {
                    if (controller.isLoadingSaved.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.xxl),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (controller.hasSavedError.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.xxl),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.error_outline_rounded, size: 44, color: textSecondary),
                              const SizedBox(height: AppSizes.sm),
                              Text('Could not load saved trips.', style: TextStyle(color: textSecondary)),
                              const SizedBox(height: AppSizes.sm),
                              ElevatedButton(onPressed: controller.fetchSaved, child: const Text('Retry')),
                            ],
                          ),
                        ),
                      );
                    }
                    final saved = controller.savedTrips;
                    if (saved.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.xxl),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.favorite_border_rounded, size: 44, color: textSecondary),
                              const SizedBox(height: AppSizes.sm),
                              Text('No saved trips yet.', style: TextStyle(color: textSecondary)),
                            ],
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: saved
                          .map((trip) => SavedTripCard(
                        key: ValueKey(trip.id),
                        trip: trip,
                        onTap: () => Get.to(() => TripDetailScreen(tripId: trip.id)),
                        onRemove: () => controller.toggleSaved(trip.id),
                      ))
                          .toList(),
                    );
                  }

                  // ---- Upcoming / Completed / Cancelled ----
                  final bookings = controller.filteredBookings;
                  if (bookings.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.xxl),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.travel_explore_rounded, size: 44, color: textSecondary),
                            const SizedBox(height: AppSizes.sm),
                            Text('No trips here yet.', style: TextStyle(color: textSecondary)),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: bookings
                        .map((b) => BookingTripCard(
                      key: ValueKey(b.id),
                      booking: b,
                      relativeLabel: controller.relativeLabel(b.selectedDate),
                      onTap: () => Get.to(() => TripDetailScreen(tripId: b.tripId)),
                      onItinerary: () {
                        if (b.itineraryPdfUrl.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No itinerary PDF available for this trip.')),
                          );
                          return;
                        }
                        Get.to(() => PdfViewerScreen(pdfUrl: b.itineraryPdfUrl, title: b.tripTitle));
                      },
                      onManage: () => showManageBookingSheet(
                        context,
                        booking: b,
                        onConfirmCancel: () => controller.cancelBooking(b.id),
                      ),
                      onContactSupport: () => showContactSupportSheet(context, booking: b),
                    ))
                        .toList(),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
}

String _sectionTitle(BookingTab tab) {
  switch (tab) {
    case BookingTab.upcoming:
      return 'Upcoming Trips';
    case BookingTab.completed:
      return 'Completed Trips';
    case BookingTab.cancelled:
      return 'Cancelled Trips';
    case BookingTab.saved:
      return 'Saved Trips';
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textSecondary = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Icon(icon, size: 22, color: isSelected ? AppColors.primary : textSecondary),
              const SizedBox(height: 3),
              Text(label, style: TextStyle(fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : textSecondary)),
              const SizedBox(height: 4),
              Container(height: 2, width: 60, color: isSelected ? AppColors.primary : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}