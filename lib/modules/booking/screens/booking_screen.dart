import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../tripdetails/models/trip_model.dart';
import '../controllers/booking_controller.dart';
import '../widgets/booking_calendar.dart';
import '../widgets/traveler_counter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'customer_info_screen.dart';

class BookingScreen extends StatelessWidget {
  final TripModel trip;
  final DateTime? initialDate;
  const BookingScreen({super.key, required this.trip, this.initialDate});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController(trip, initialDate: initialDate));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final badgeBg = AppColors.primary.withValues(alpha: 0.08);
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: textPrimary), onPressed: () => Get.back()),
        title: Text('Booking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.md),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, size: 19, color: AppColors.primary),
                const SizedBox(width: 4),
                const Text('Secure Booking', style: TextStyle(fontSize: 13.5, color: AppColors.primary, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Trip Summary Card =====
            Padding(
              padding: const EdgeInsets.all(AppSizes.sm),
              child: Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 125,
                          height: 150,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              trip.coverImage.isNotEmpty ? Image.network(trip.coverImage, fit: BoxFit.cover,)
                                  : Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_outlined, size: 35, color: Colors.grey,),
                              ),

                              // Subtle bottom gradient
                              Positioned(left: 0, right: 0, bottom: 0, height: 55,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // TRIP DETAILS
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 12, 11,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TITLE
                                Text(trip.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, height: 1.18, letterSpacing: -0.2, color: textPrimary,),
                                ),
                                const SizedBox(height: 8),
                                // LOCATION
                                Row(
                                  children: [
                                    const Icon(Icons.place_outlined, size: 16, color: AppColors.primary,),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(trip.location, maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 13.5, color: textSecondary, fontWeight: FontWeight.w600,),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 9),
                                // DURATION
                                _MiniTag(icon: Iconsax.calendar_1_copy, label: '${trip.duration} Days / $nights Nights',),
                                const SizedBox(height: 7),
                                // TOUR TYPE
                                _MiniTag(icon: Icons.groups_3_outlined, label: trip.tourMode == 'private' ? 'Private Tour' : 'Group Tour',),
                                const Spacer(),

                                // RATING
                                Obx(() {
                                  if (controller.liveReviewCount.value == 0) {
                                    return const SizedBox.shrink();
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star_rounded, size: 16, color: Colors.amber,),
                                        const SizedBox(width: 3),
                                        Text(controller.liveRating.value.toStringAsFixed(1),
                                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: textPrimary,),
                                        ),
                                        const SizedBox(width: 3),
                                        Text('(${controller.liveReviewCount.value} Reviews)',
                                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textSecondary,),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ===== Pickup / Best Time / Tour Type Band =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.sm, horizontal: AppSizes.sm),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _InfoChip(icon: Icons.location_on_rounded, label: 'Pick-up', value: trip.meetingPoint.isNotEmpty ? trip.meetingPoint : 'TBD'),
                      const _InfoDivider(),
                      _InfoChip(icon: Icons.event_note_rounded, label: 'Best Time', value: 'May - Oct'),
                      const _InfoDivider(),
                      _InfoChip(icon: Icons.terrain_rounded, label: 'Tour Type', value: trip.type.isNotEmpty ? trip.type[0].toUpperCase() + trip.type.substring(1) : ''),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // ===== Select Date + Select Travelers (side by side, equal height) =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 12,
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.sm ),
                        decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Select Date', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary)),
                            const SizedBox(height: AppSizes.sm),
                            Obx(() => BookingCalendar(
                              visibleMonth: controller.visibleMonth.value,
                              selectedDate: controller.draft.value.selectedDate,
                              availableDates: trip.availableDates,
                              onDateSelected: controller.selectDate,
                              onPrevMonth: () => controller.changeMonth(-1),
                              onNextMonth: () => controller.changeMonth(1),
                            )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      flex: 11,
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.sm),
                        decoration: BoxDecoration(color: surface,
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                            border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.10), width: 1,
                      ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Select Travelers', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary)),
                            Obx(() => TravelerCounter(
                              title: 'Adults',
                              subtitle: '(12+ years)',
                              value: controller.draft.value.adults,
                              minValue: 1,
                              onChanged: controller.setAdults,
                            )),
                            const Divider(height: 1),
                            Obx(() => TravelerCounter(
                              title: 'Children',
                              subtitle: '(5 - 11 years)',
                              value: controller.draft.value.children,
                              onChanged: controller.setChildren,
                            )),
                            const Divider(height: 1),
                            Obx(() => TravelerCounter(
                              title: 'Infants',
                              subtitle: '(0 - 4 years)',
                              value: controller.draft.value.infants,
                              onChanged: controller.setInfants,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // ===== Price Summary =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    width: 1,
                  ),
                ),
                child: Obx(() {
                  final d = controller.draft.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price Summary', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary)),
                      const SizedBox(height: AppSizes.sm),
                      _PriceRow(label: 'Tour Price (Per Adult)', value: 'PKR ${trip.price.toStringAsFixed(0)}', textSecondary: textSecondary, textPrimary: textPrimary),
                      if (d.children > 0)
                        _PriceRow(
                          label: 'Children (${d.children} × PKR ${trip.effectiveChildPrice.toStringAsFixed(0)})',
                          value: 'PKR ${controller.childTotal.toStringAsFixed(0)}',
                          textSecondary: textSecondary,
                          textPrimary: textPrimary,
                        ),
                      const Divider(height: AppSizes.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary)),
                          Text('PKR ${controller.grandTotal.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // ===== Trust Badges Band =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 4, horizontal: AppSizes.sm),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _TrustBadge(icon: Icons.verified_rounded, label: 'Free Cancellation', sub: 'Up to 48 hours'),
                    _TrustBadge(icon: Icons.sell_rounded, label: 'Best Price', sub: 'Guaranteed'),
                    _TrustBadge(icon: Icons.lock_rounded, label: 'Secure Payment', sub: '100% Safe'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== Continue Button =====
      bottomNavigationBar: Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 4),
          decoration: BoxDecoration(
            color: surface,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -4))],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                onPressed: controller.canProceed
                    ? () => Get.to(() => const CustomerInfoScreen())
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Continue to Book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 19),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MiniTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final textSecondary = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 13, color: textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}


class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon container
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary,),
        ),
        const SizedBox(width: 9),
        // Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w800, height: 1.1,),),
            const SizedBox(height: 3),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 105,),
              child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: textPrimary, height: 1.1,),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: AppColors.primary.withValues(alpha: 0.14),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textSecondary;
  final Color textPrimary;
  const _PriceRow({required this.label, required this.value, required this.textSecondary, required this.textPrimary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13.5, color: textSecondary)),
          Text(value, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: textPrimary)),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;

  const _TrustBadge({
    required this.icon,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 21, color: AppColors.primary,),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.primary, height: 1.15,),
            ),
            const SizedBox(height: 2),
            Text(sub, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: textSecondary, height: 1.15,),
            ),
          ],
        ),
      ),
    );
  }
}