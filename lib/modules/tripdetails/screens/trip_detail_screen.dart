import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/tripdetails/screens/pdf_viewer_screen.dart';
import 'package:intl/intl.dart';
import '../../../services/exchange_rate_services.dart';
import '../../booking/screens/booking_screen.dart';
import '../controllers/trip_detail_controller.dart';
import '../models/review_model.dart';
import '../services/share_service.dart';
import '../widgets/review_sheet.dart';
import '../widgets/trip_available_dates_section.dart';
import '../widgets/trip_image_carousel.dart';
import '../widgets/trip_description_section.dart';
import '../widgets/trip_highlights_section.dart';
import '../widgets/trip_inclusions_section.dart';
import '../widgets/trip_itinerary_section.dart';
import '../widgets/trip_gallery_section.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../widgets/trip_map_section.dart';
import '../widgets/trip_reviews_section.dart';
import '../models/trip_model.dart';
import '../widgets/trip_terms_section.dart';
import 'all_reviews_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final String tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripDetailController(tripId), tag: tripId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final trip = controller.trip.value;
          return Text(
            trip?.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: textPrimary),
          );
        }),
        actions: [
          Obx(() {
            final trip = controller.trip.value;
            if (trip == null) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.ios_share_rounded, color: textPrimary),
              onPressed: () => ShareService.shareTrip(trip),
            );
          }),
          Obx(() => IconButton(
            icon: Icon(
              controller.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: controller.isFavorite ? AppColors.favoriteRed : textPrimary,
            ),
            onPressed: controller.toggleFavorite,
          )),
          const SizedBox(width: AppSizes.xs),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final trip = controller.trip.value;
        if (trip == null) {
          final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 48, color: textSecondary),
                const SizedBox(height: AppSizes.sm),
                Text('Trip not found', style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final isFullyBooked = trip.remainingSeats != null && trip.remainingSeats! <= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 4),
      decoration: BoxDecoration(
        color: surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(double.infinity, 44),
            ),
              onPressed: isFullyBooked
                  ? null
                  : () => Get.to(() => BookingScreen(
                trip: trip,
                initialDate: trip.availableDates.isNotEmpty ? trip.availableDates.first.date : null,
              )),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    final coverImages = [trip.coverImage].where((u) => u.isNotEmpty).toList();
    final galleryImages = trip.gallery.where((u) => u.isNotEmpty).toList();
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Image carousel — no overlay icons anymore, they live in the AppBar =====
          Obx(() => TripImageCarousel(
            images: coverImages,
            currentIndex: controller.carouselIndex.value,
            onPageChanged: controller.setCarouselIndex,
          )),

          // ===== Header Info Section =====
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.location_on_rounded, size: 18, color: textSecondary),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(trip.location, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, color: textSecondary, fontWeight: FontWeight.w600, height: 1.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('PKR ${trip.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    if (trip.originalPrice != null && trip.originalPrice! > trip.price) ...[
                      const SizedBox(width: 8),
                      Text('PKR ${trip.originalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 14, color: textSecondary, decoration: TextDecoration.lineThrough)),
                    ],
                  ],
                ),
                const SizedBox(height: 2),

                FutureBuilder<double>(
                  future: ExchangeRateService.getUsdToPkrRate(),
                  builder: (context, snapshot) {
                    final rate = snapshot.data;
                    if (rate == null) return const SizedBox.shrink();
                    return Text(
                      '≈ \$${(trip.price / rate).toStringAsFixed(2)} USD',
                      style: TextStyle(fontSize: 16, color: textSecondary, fontWeight: FontWeight.w600),
                    );
                  },
                ),
                const SizedBox(height: AppSizes.xs),
                Obx(() {
                  final reviews = controller.reviews;
                  final liveRating = reviews.isEmpty
                      ? 0.0
                      : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
                  final liveCount = reviews.length;

                  return Row(
                    children: [
                      if (liveCount > 0) ...[
                        const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(liveRating.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textPrimary)),
                        Text(' ($liveCount reviews)', style: TextStyle(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(width: AppSizes.md),
                      ],
                      Icon(Icons.calendar_today_rounded, size: 15, color: textSecondary),
                      const SizedBox(width: 4),
                      Text('${trip.duration} Days · $nights Nights',
                          style: TextStyle(color: textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  );
                }),
                const SizedBox(height: AppSizes.xs),

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
                          fontSize: 13,
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
                const SizedBox(height: AppSizes.sm),

                TripGallerySection(images: galleryImages),
                const SizedBox(height: AppSizes.lg),

                TripItinerarySection(
                  itinerary: trip.itinerary,
                  pdfUrl: trip.itineraryPdfUrl,
                  tripTitle: trip.title,
                  onViewPdf: () {
                    Get.to(() => PdfViewerScreen(pdfUrl: trip.itineraryPdfUrl, title: trip.title));
                  },
                ),
                const SizedBox(height: AppSizes.sm),

                TripInclusionsSection(inclusions: trip.inclusions, exclusions: trip.exclusions),
                const SizedBox(height: AppSizes.sm),

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
                const SizedBox(height: AppSizes.md),

                // ===== Reviews — only 3 shown here, "Show all" opens the
                Obx(() {
                  final reviews = controller.reviews;
                  final liveRating = reviews.isEmpty
                      ? 0.0
                      : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
                  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

                  void openEdit(ReviewModel review) {
                    showWriteReviewSheet(
                      context,
                      initialRating: review.rating,
                      initialComment: review.comment,
                      onSubmit: (rating, comment) =>
                          controller.updateReview(reviewId: review.id, rating: rating, comment: comment),
                      onDelete: () => controller.deleteReview(reviewId: review.id),
                    );
                  }

                  return TripReviewsSection(
                    rating: liveRating,
                    reviewCount: reviews.length,
                    reviews: reviews,
                    currentUserId: currentUserId,
                    onWriteReview: () => showWriteReviewSheet(
                      context,
                      onSubmit: (rating, comment) => controller.submitReview(rating: rating, comment: comment),
                    ),
                    onEditReview: openEdit,
                    onViewAll: () => Get.to(() => AllReviewsScreen(
                      rating: liveRating,
                      reviews: reviews,
                      currentUserId: currentUserId,
                      onEditReview: openEdit,
                    )),
                  );
                }),
                const SizedBox(height: AppSizes.md),
              ],
            ),
          ),
        ],
      ),
    );
  }
}