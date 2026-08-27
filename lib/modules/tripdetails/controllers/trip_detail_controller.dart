import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/review_model.dart';
import '../../../services/trip_service.dart';
import '../../../services/review_service.dart';
import '../../../services/recently_viewed_service.dart';
import '../models/trip_date_slot.dart';
import '../models/trip_model.dart';

class TripDetailController extends GetxController {
  final String tripId;
  TripDetailController(this.tripId);

  final Rx<TripModel?> trip = Rx<TripModel?>(null);
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isFavorite = false.obs;
  final RxInt carouselIndex = 0.obs;
  final Rx<TripDateSlot?> selectedSlot = Rx<TripDateSlot?>(null);

  void selectSlot(TripDateSlot slot) => selectedSlot.value = slot;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        TripService.getTripById(tripId),
        ReviewService.getReviewsForTrip(tripId),
      ]);
      trip.value = results[0] as TripModel?;
      reviews.value = results[1] as List<ReviewModel>;

      // ===== Default: pehli available date select ho jaye =====
      if (trip.value != null && trip.value!.availableDates.isNotEmpty) {
        selectedSlot.value = trip.value!.availableDates.first;
      }

      await RecentlyViewedService.addTripId(tripId);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void setCarouselIndex(int index) => carouselIndex.value = index;

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  Future<void> submitReview({required double rating, required String comment}) async {
    final user = FirebaseAuth.instance.currentUser;
    await ReviewService.addReview(
      tripId: tripId,
      userId: user?.uid ?? '',
      userName: user?.displayName ?? user?.email?.split('@').first ?? 'Traveler',
      userPhoto: user?.photoURL ?? '',
      rating: rating,
      comment: comment,
    );
    reviews.value = await ReviewService.getReviewsForTrip(tripId);
  }

  Future<void> updateReview({required String reviewId, required double rating, required String comment}) async {
    await ReviewService.updateReview(tripId: tripId, reviewId: reviewId, rating: rating, comment: comment);
    reviews.value = await ReviewService.getReviewsForTrip(tripId);
  }

  Future<void> deleteReview({required String reviewId}) async {
    await ReviewService.deleteReview(tripId: tripId, reviewId: reviewId);
    reviews.value = await ReviewService.getReviewsForTrip(tripId);
  }

}