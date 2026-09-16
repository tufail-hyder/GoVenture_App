import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../tripdetails/models/trip_model.dart';
import '../models/banner_model.dart';
import '../models/blog_model.dart';
import '../../mybookings/models/upcoming_booking_model.dart';
import '../../../services/trip_service.dart';
import '../services/banner_service.dart';
import '../services/blog_service.dart';
import '../../../services/recently_viewed_service.dart';
import '../../../core/constants/app_text.dart';
import '../models/destination_model.dart';
import '../services/destination_service.dart';

class HomeController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString greeting = ''.obs;

  final RxBool hasUnreadNotifications = false.obs;

  final RxList<TripModel> topExperiences = <TripModel>[].obs;
  final RxList<TripModel> featuredTrips = <TripModel>[].obs;
  final RxList<TripModel> popularTrips = <TripModel>[].obs;
  final RxList<TripModel> recommendedTrips = <TripModel>[].obs;
  final RxList<TripModel> recentlyViewedTrips = <TripModel>[].obs;
  final RxList<TripModel> workcationTrips = <TripModel>[].obs;
  final RxList<TripModel> adventureTrips = <TripModel>[].obs;
  final RxList<TripModel> retreatTrips = <TripModel>[].obs;
  final RxList<UpcomingBookingModel> upcomingBookings = <UpcomingBookingModel>[].obs;
  final RxList<BlogModel> blogPosts = <BlogModel>[].obs;
  final Rxn<BannerModel> banner = Rxn<BannerModel>();
  final RxList<TripModel> upcomingTrips = <TripModel>[].obs;
  final RxList<DestinationModel> popularDestinations = <DestinationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _setGreeting();
    fetchHomeData();
    BannerService.getActiveBanner().then((b) => print('Banner test: $b'));
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    final name = FirebaseAuth.instance.currentUser?.displayName?.split(' ').first;
    final timeGreeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    greeting.value = name != null ? '$timeGreeting, $name' : '$timeGreeting, Explorer';
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      final recentIds = RecentlyViewedService.getIds();
      final uid = FirebaseAuth.instance.currentUser?.uid;

      featuredTrips.value = await _safeCall(() => TripService.getFeaturedTrips(), 'featuredTrips');
      popularTrips.value = await _safeCall(() => TripService.getPopularTrips(), 'popularTrips');
      popularDestinations.value = await _safeCall(() => DestinationService.getPopularDestinations(), 'popularDestinations',);
      recentlyViewedTrips.value = await _safeCall(() => TripService.getTripsByIds(recentIds), 'recentlyViewed');
      workcationTrips.value = await _safeCall(() => TripService.getTripsByType(AppTexts.tripTypeWorkcation), 'workcation');
      adventureTrips.value = await _safeCall(() => TripService.getTripsByType(AppTexts.tripTypeAdventure), 'adventure');
      retreatTrips.value = await _safeCall(() => TripService.getTripsByType(AppTexts.tripTypeRetreat), 'retreat');
      banner.value = await _safeCallNullable(() => BannerService.getActiveBanner(), 'banner');
      blogPosts.value = await _safeCall(() => BlogService.getLatestBlogs(), 'blogPosts');
      topExperiences.value = await _safeCall(() => TripService.getTopExperiences(), 'topExperiences');
      upcomingTrips.value = await _safeCall(() => TripService.getUpcomingTrips(), 'upcomingTrips');

      final shownIds = [...featuredTrips.map((t) => t.id), ...popularTrips.map((t) => t.id)];
      recommendedTrips.value = await _safeCall(
            () => TripService.getRecommendedTrips(excludeIds: shownIds),
        'recommendedTrips',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<T>> _safeCall<T>(Future<List<T>> Function() call, String label) async {
    try {
      return await call();
    } catch (e) {
      // ignore: avoid_print
      print('❌ $label failed: $e');
      return <T>[];
    }
  }

  Future<T?> _safeCallNullable<T>(Future<T?> Function() call, String label) async {
    try {
      return await call();
    } catch (e, st) {
      print('❌ $label failed: $e');
      return null;
    }
  }

  Future<void> refresh() => fetchHomeData();
}