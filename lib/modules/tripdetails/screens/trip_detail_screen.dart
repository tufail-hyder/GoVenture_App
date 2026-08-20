import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/trip_detail_controller.dart';
import '../widgets/trip_image_carousel.dart';
import '../widgets/trip_description_section.dart';
import '../widgets/trip_highlights_section.dart';
import '../widgets/trip_itinerary_section.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

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

        final images = [trip.coverImage, ...trip.gallery].where((u) => u.isNotEmpty).toList();
        final nights = trip.duration > 0 ? trip.duration - 1 : 0;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Step 5: Image Carousel =====
                  Obx(() => TripImageCarousel(
                    images: images,
                    currentIndex: controller.carouselIndex.value,
                    onPageChanged: controller.setCarouselIndex,
                    isFavorite: controller.isFavorite.value,
                    onFavoriteTap: controller.toggleFavorite,
                    onShareTap: () {
                      // Step mein aage Share Plus se implement karenge
                    },
                    onBackTap: () => Get.back(),
                  )),

                  // ===== Header Info Section =====
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimaryLight),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 16, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                trip.location,
                                style: const TextStyle(fontSize: 14, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm),

                        // ===== Rating + Duration Row =====
                        Row(
                          children: [
                            if (trip.rating > 0) ...[
                              const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                              const SizedBox(width: 3),
                              Text(
                                trip.rating.toStringAsFixed(1),
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                              Text(
                                ' (${trip.reviewCount} reviews)',
                                style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
                              ),
                              const SizedBox(width: AppSizes.md),
                            ],
                            const Icon(Icons.calendar_today_rounded, size: 15, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 3),
                            Text(
                              '${trip.duration} Days · $nights Nights',
                              style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),

                        // ===== Remaining Seats (agar applicable ho) =====
                        if (trip.remainingSeats != null) ...[
                          const SizedBox(height: AppSizes.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: trip.remainingSeats! <= 5 ? AppColors.error.withValues(alpha: 0.1) : AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                            ),
                            child: Text(
                              trip.remainingSeats! <= 0
                                  ? 'Fully Booked'
                                  : '${trip.remainingSeats} seats left',
                              style: TextStyle(
                                color: trip.remainingSeats! <= 5 ? AppColors.error : AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ===== Step 6: Description + Highlights + Itinerary =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TripDescriptionSection(description: trip.shortDescription),
                        const SizedBox(height: AppSizes.lg),

                        TripHighlightsSection(highlights: trip.highlights),
                        const SizedBox(height: AppSizes.lg),

                        TripItinerarySection(
                          itinerary: trip.itinerary,
                          pdfUrl: trip.itineraryPdfUrl,
                          onViewPdf: () {
                            // Step mein aage PDF viewer se connect karenge
                          },
                        ),
                        const SizedBox(height: AppSizes.lg),

                        // ===== Baaki sections (Inclusions/Exclusions, Maps, Reviews) — agle steps mein =====
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== Book Now Bar (sticky, screen ke bottom par hamesha visible) =====
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -4)),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('FROM', style: TextStyle(fontSize: 10, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600)),
                            Text(
                              'PKR ${trip.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14)),
                        onPressed: (trip.remainingSeats != null && trip.remainingSeats! <= 0)
                            ? null
                            : () {
                          // Step 9 (Booking Form) mein connect karenge
                        },
                        child: const Text('Book Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}