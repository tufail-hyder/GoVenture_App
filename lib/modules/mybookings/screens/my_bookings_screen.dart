import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_bookings_controller.dart';
import '../widgets/booking_trip_card.dart';
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
        centerTitle: true,
        title: Text('My Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.md),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.notifications_none_rounded, color: textPrimary),
                Positioned(
                  top: -1, right: -1,
                  child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSizes.xl),
            children: [
              // ===== Tabs =====
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
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
                      isSelected: false,
                      onTap: () {
                        // Saved/Favorites — alag feature, baad mein connect karenge
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: AppSizes.md),

              // ===== Promo Banner =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [AppColors.primaryDarkMode.withValues(alpha: 0.25), AppColors.primaryDarkMode.withValues(alpha: 0.1)]
                          : [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.4)],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your Adventure Awaits!', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: textPrimary)),
                            const SizedBox(height: 3),
                            Text('View your upcoming trips, manage bookings and get ready for unforgettable memories.',
                                style: TextStyle(fontSize: 11.5, color: textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.hiking_rounded, size: 44, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // ===== Section Header =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _sectionTitle(controller.selectedTab.value),   // <-- dynamic
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary),
                    ),
                    Text('View All', style: TextStyle(fontSize: 12.5, color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sm),

              // ===== Bookings List =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Builder(builder: (context) {
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
                    children: bookings.map((b) => BookingTripCard(
                      booking: b,
                      relativeLabel: controller.relativeLabel(b.selectedDate),
                      onTap: () {},
                      onItinerary: () {},
                      onVoucher: () {},
                      onManage: () => showManageBookingSheet(
                        context,
                        booking: b,
                        onConfirmCancel: () => controller.cancelBooking(b.id),
                      ),
                      onContactSupport: () {},
                    )).toList(),
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
              Icon(icon, size: 18, color: isSelected ? AppColors.primary : textSecondary),
              const SizedBox(height: 3),
              Text(label,
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : textSecondary)),
              const SizedBox(height: 4),
              Container(height: 2, width: 30, color: isSelected ? AppColors.primary : Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}