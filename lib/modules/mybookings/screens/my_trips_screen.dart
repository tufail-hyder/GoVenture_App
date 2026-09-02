import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../booking/models/booking_model.dart';
import '../controllers/my_trips_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyTripsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('My Trips', style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w800, color: textPrimary)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSizes.md),
              child: Stack(
                children: [
                  Icon(Icons.notifications_none_rounded, color: textPrimary, size: AppSizes.iconLg - 4),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(46),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: TabBar(
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: textSecondary,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                tabs: const [
                  Tab(icon: Icon(Icons.check_circle_outline_rounded, size: 18), text: 'Upcoming'),
                  Tab(icon: Icon(Icons.circle_outlined, size: 18), text: 'Completed'),
                  Tab(icon: Icon(Icons.cancel_outlined, size: 18), text: 'Cancelled'),
                  Tab(icon: Icon(Icons.favorite_border_rounded, size: 18), text: 'Saved'),
                ],
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          return TabBarView(
            children: [
              _TripsList(
                bookings: controller.upcoming,
                controller: controller,
                surface: surface,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                showBanner: true,
                statusLabel: 'Upcoming',
              ),
              _TripsList(
                bookings: controller.completed,
                controller: controller,
                surface: surface,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                showBanner: false,
                statusLabel: 'Completed',
              ),
              _TripsList(
                bookings: controller.cancelled,
                controller: controller,
                surface: surface,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                showBanner: false,
                statusLabel: 'Cancelled',
              ),
              Center(child: Text('No saved trips yet', style: TextStyle(color: textSecondary))),
            ],
          );
        }),
      ),
    );
  }
}

class _TripsList extends StatelessWidget {
  const _TripsList({
    required this.bookings,
    required this.controller,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.showBanner,
    required this.statusLabel,
  });

  final List<BookingModel> bookings;
  final MyTripsController controller;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final bool showBanner;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: Text('No trips here yet', style: TextStyle(color: textSecondary, fontSize: AppSizes.fontSm)),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.xl),
      children: [
        if (showBanner) ...[
          _AdventureBanner(surface: surface, textPrimary: textPrimary, textSecondary: textSecondary),
          const SizedBox(height: AppSizes.lg),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$statusLabel Trips', style: TextStyle(fontWeight: FontWeight.w800, fontSize: AppSizes.fontMd, color: textPrimary)),
            Row(
              children: [
                Text('View All', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm + 4),
        ...bookings.map((b) => Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.md),
          child: _BookingCard(
            booking: b,
            badgeLabel: controller.badgeFor(b.selectedDate),
            statusLabel: statusLabel,
            surface: surface,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        )),
      ],
    );
  }
}

class _AdventureBanner extends StatelessWidget {
  const _AdventureBanner({required this.surface, required this.textPrimary, required this.textSecondary});
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
            child: const Icon(Icons.event_available_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Adventure Awaits!',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: textPrimary)),
                const SizedBox(height: 3),
                Text('View your upcoming trips, manage bookings and get ready for unforgettable memories.',
                    style: TextStyle(fontSize: AppSizes.fontXs, color: textSecondary, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.badgeLabel,
    required this.statusLabel,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });

  final BookingModel booking;
  final String badgeLabel;
  final String statusLabel;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;

  String _fmtDate(DateTime d) => '${_month(d.month)} ${d.day}';
  String _month(int m) => const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m];

  @override
  Widget build(BuildContext context) {
    final endDate = booking.selectedDate.add(Duration(days: booking.tripDuration > 0 ? booking.tripDuration - 1 : 0));
    final nights = booking.tripDuration > 0 ? booking.tripDuration - 1 : 0;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      onTap: () {
        // TODO: Get.to(() => BookingDetailScreen(bookingId: booking.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 14, offset: Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Header row: image + info =====
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm + 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd + 2),
                        child: SizedBox(
                          width: 88,
                          height: 100,
                          child: booking.tripCoverImage.isNotEmpty
                              ? Image.network(booking.tripCoverImage, fit: BoxFit.cover)
                              : Container(color: AppColors.dividerLight),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppSizes.radiusSm - 2)),
                          child: Text(badgeLabel, style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.tripTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: AppSizes.fontMd - 1, color: textPrimary)),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, size: 13, color: textSecondary),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                booking.tripLocation.isNotEmpty ? booking.tripLocation : '—',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: textSecondary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 12.5, color: textSecondary),
                            const SizedBox(width: 4),
                            Text('${_fmtDate(booking.selectedDate)} - ${_fmtDate(endDate)}, ${endDate.year}',
                                style: TextStyle(fontSize: 11.5, color: textSecondary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time_filled_rounded, size: 12.5, color: textSecondary),
                            const SizedBox(width: 4),
                            Text('${booking.tripDuration} Days / $nights Nights',
                                style: TextStyle(fontSize: 11.5, color: textSecondary, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.people_alt_rounded, size: 12.5, color: textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              '${booking.adults} Adult${booking.adults > 1 ? 's' : ''}'
                                  '${booking.children > 0 ? ', ${booking.children} Child${booking.children > 1 ? 'ren' : ''}' : ''}',
                              style: TextStyle(fontSize: 11.5, color: textSecondary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppSizes.radiusSm - 2),
                          ),
                          child: Text('• $statusLabel',
                              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: textSecondary),
                ],
              ),
            ),

            // ===== Booking ID row =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Booking ID: ', style: TextStyle(fontSize: 11, color: textSecondary)),
                  Text(booking.id, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Divider(height: 1, color: textSecondary.withValues(alpha: 0.12)),

            // ===== Action row =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  _ActionButton(icon: Icons.map_rounded, label: 'Itinerary', textSecondary: textSecondary, onTap: () {
                    // TODO: Get.to(() => ItineraryScreen(bookingId: booking.id));
                  }),
                  _ActionButton(icon: Icons.confirmation_num_rounded, label: 'Voucher', textSecondary: textSecondary, onTap: () {
                    // TODO: Get.to(() => VoucherScreen(bookingId: booking.id));
                  }),
                  _ActionButton(icon: Icons.tune_rounded, label: 'Manage', textSecondary: textSecondary, onTap: () {
                    // TODO: Get.to(() => ManageBookingScreen(bookingId: booking.id));
                  }),
                  _ActionButton(icon: Icons.support_agent_rounded, label: 'Support', textSecondary: textSecondary, onTap: () {
                    // TODO: Get.to(() => ContactSupportScreen(bookingId: booking.id));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.textSecondary, required this.onTap});
  final IconData icon;
  final String label;
  final Color textSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd - 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(height: 3),
              Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}