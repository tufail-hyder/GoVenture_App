import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/trip_model.dart';
import '../../../models/review_model.dart';
import '../../../services/trip_service.dart';
import '../../../services/review_service.dart';
import '../../../services/recently_viewed_service.dart';

class TripDetailController extends GetxController {
  final String tripId;
  TripDetailController(this.tripId);

  final Rx<TripModel?> trip = Rx<TripModel?>(null);
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isFavorite = false.obs;
  final RxInt carouselIndex = 0.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  void selectDate(DateTime date) => selectedDate.value = date;

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

      await RecentlyViewedService.addTripId(tripId);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite() {
    // TODO: Firestore ke `users/{uid}/favorites` collection ke sath persist karna
    isFavorite.value = !isFavorite.value;
  }

  void setCarouselIndex(int index) => carouselIndex.value = index;

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
}