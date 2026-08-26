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

    // ---- Trip and reviews are fetched independently: if the reviews query
    // fails (missing index, bad data, etc.) it no longer prevents the trip
    // itself from loading and being shown. ----
    try {
      trip.value = await TripService.getTripById(tripId);
    } catch (e) {
      trip.value = null;
    }

    try {
      reviews.value = await ReviewService.getReviewsForTrip(tripId);
    } catch (e) {
      reviews.value = [];
    }

    // ---- This MUST come before the "recently viewed" call below. Recording
    // a recently-viewed trip is a non-critical side effect — it should never
    // be able to block the loading spinner from resolving. Previously it was
    // awaited inside the same try/finally as the trip fetch, so if this call
    // ever hung (offline, slow network, etc.) isLoading.value never flipped
    // to false and the screen was stuck on the spinner forever. ----
    isLoading.value = false;

    // Fire-and-forget: run in the background, swallow any failure.
    RecentlyViewedService.addTripId(tripId).catchError((_) {});
  }

  void toggleFavorite() {
    // TODO: Firestore ke `users/{uid}/favorites` collection ke sath persist karna
    isFavorite.value = !isFavorite.value;
  }

  void setCarouselIndex(int index) => carouselIndex.value = index;

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
}