import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/tripdetails/screens/pdf_viewer_screen.dart';
import 'package:intl/intl.dart';
import '../controllers/trip_detail_controller.dart';
import '../services/share_service.dart';
import '../widgets/trip_available_dates_section.dart';
import '../widgets/trip_image_carousel.dart';
import '../widgets/trip_description_section.dart';
import '../widgets/trip_highlights_section.dart';
import '../widgets/trip_inclusions_section.dart';
import '../widgets/trip_itinerary_section.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../widgets/trip_map_section.dart';
import '../widgets/trip_reviews_section.dart';
import '../models/trip_model.dart';


class TripDetailScreen extends StatelessWidget {
  final String tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripDetailController(tripId), tag: tripId);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final trip = controller.trip.value;
        if (trip == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.textSecondaryLight),
                const SizedBox(height: AppSizes.sm),
                const Text('Trip not found'),
                const SizedBox(height: AppSizes.md),
                ElevatedButton(onPressed: () => Get.back(), child: const Text('Go Back')),
              ],
            ),
          );
        }

        return _TripDetailBody(controller: controller, trip: trip);
      }),
      bottomNavigationBar: Obx(() {
        final trip = controller.trip.value;
        if (trip == null) return const SizedBox.shrink();
        return _BookNowBar(trip: trip);
      }),
    );
  }
}

class _BookNowBar extends StatelessWidget {
  const _BookNowBar({required this.trip});
  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final isFullyBooked = trip.remainingSeats != null && trip.remainingSeats! <= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 44,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(double.infinity, 44),
            ),
            onPressed: isFullyBooked ? null : () {},
            child: Text(
              isFullyBooked ? 'Fully Booked' : 'Book Now',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

class _TripDetailBody extends StatelessWidget {
  const _TripDetailBody({required this.controller, required this.trip});

  final TripDetailController controller;
  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    final images = [trip.coverImage, ...trip.gallery].where((u) => u.isNotEmpty).toList();
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Obx(() => TripImageCarousel(
                images: images,
                currentIndex: controller.carouselIndex.value,
                onPageChanged: controller.setCarouselIndex,
              )),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AppBarIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Get.back(),
                      ),
                      Row(
                        children: [
                          _AppBarIconButton(
                            icon: Icons.ios_share_rounded,
                            onTap: () => ShareService.shareTrip(trip),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Obx(() => _AppBarIconButton(
                            icon: controller.isFavorite.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            iconColor: controller.isFavorite.value ? AppColors.favoriteRed : Colors.white,
                            onTap: controller.toggleFavorite,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ===== Header Info Section =====
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimaryLight),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textSecondaryLight),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(trip.location,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('PKR ${trip.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    if (trip.originalPrice != null && trip.originalPrice! > trip.price) ...[
                      const SizedBox(width: 8),
                      Text('PKR ${trip.originalPrice!.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight, decoration: TextDecoration.lineThrough)),
                    ],
                  ],
                ),const SizedBox(height: 2),
                Text(
                  '≈ \$${(trip.price / 279.0).toStringAsFixed(2)} USD',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: AppSizes.sm),

                Row(
                  children: [
                    if (trip.rating > 0) ...[
                      const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(trip.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      Text(' (${trip.reviewCount} reviews)', style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13)),
                      const SizedBox(width: AppSizes.md),
                    ],
                    const Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.textSecondaryLight),
                    const SizedBox(width: 3),
                    Text('${trip.duration} Days · $nights Nights',
                        style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Obx(() {
                  final slot = controller.selectedSlot.value;
                  if (slot == null || slot.remainingSeats == null) return const SizedBox.shrink();
                  final remaining = slot.remainingSeats!;
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSizes.sm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: remaining <= 5 ? AppColors.error.withValues(alpha: 0.1) : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(
                        remaining <= 0
                            ? 'Fully Booked for ${DateFormat('MMM d').format(slot.date)}'
                            : '$remaining seats left for ${DateFormat('MMM d').format(slot.date)}',
                        style: TextStyle(
                          color: remaining <= 5 ? AppColors.error : AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TripDescriptionSection(description: trip.shortDescription),
                const SizedBox(height: AppSizes.md),

                TripHighlightsSection(highlights: trip.highlights),
                const SizedBox(height: AppSizes.md),

                TripItinerarySection(
                  itinerary: trip.itinerary,
                  pdfUrl: trip.itineraryPdfUrl,
                  tripTitle: trip.title,
                  onViewPdf: () {
                    Get.to(() => PdfViewerScreen(pdfUrl: trip.itineraryPdfUrl, title: trip.title));
                  },
                ),
                const SizedBox(height: AppSizes.md),

                TripInclusionsSection(inclusions: trip.inclusions, exclusions: trip.exclusions),
                const SizedBox(height: AppSizes.md),

                TripMapSection(
                  latitude: trip.latitude,
                  longitude: trip.longitude,
                  location: trip.location,
                  meetingPoint: trip.meetingPoint,
                ),
                const SizedBox(height: AppSizes.md),

                Obx(() => TripAvailableDatesSection(
                  availableDates: trip.availableDates,
                  selectedSlot: controller.selectedSlot.value,
                  onSlotSelected: controller.selectSlot,
                  duration: trip.duration,
                )),
                const SizedBox(height: AppSizes.lg),

                TripReviewsSection(
                  rating: trip.rating,
                  reviewCount: trip.reviewCount,
                  reviews: controller.reviews,
                ),
                const SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _AppBarIconButton({required this.icon, this.iconColor = Colors.white, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}