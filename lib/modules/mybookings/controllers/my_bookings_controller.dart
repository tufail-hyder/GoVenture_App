import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../favourite/services/favourite_services.dart';
import '../../booking/models/booking_model.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../services/booking_service.dart';

enum BookingTab { upcoming, completed, cancelled, saved }

class MyBookingsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxList<BookingModel> _allBookings = <BookingModel>[].obs;
  final Rx<BookingTab> selectedTab = BookingTab.upcoming.obs;

  // ---- Saved / Favorites ----
  final RxBool isLoadingSaved = false.obs;
  final RxBool hasSavedError = false.obs;
  final RxList<TripModel> savedTrips = <TripModel>[].obs;
  bool _savedLoadedOnce = false;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  /// Loads this user's bookings from Firestore. Previously this had no
  /// catch block at all — if the query failed for ANY reason (most
  /// commonly a missing Firestore composite index on userId+createdAt,
  /// the same issue hit elsewhere in this app), the exception vanished
  /// silently, isLoading still flipped to false via finally, and the
  /// screen just showed an empty "No trips here yet" state even though
  /// the booking genuinely existed in Firestore. Now the real error is
  /// both logged and surfaced to the UI via hasError.
  Future<void> fetchBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      isLoading.value = false;
      _allBookings.value = [];
      return;
    }
    isLoading.value = true;
    hasError.value = false;
    try {
      _allBookings.value = await BookingService.getUserBookings(uid);
    } catch (e, st) {
      // ignore: avoid_print
      print('MyBookingsController.fetchBookings ERROR: $e');
      // ignore: avoid_print
      print(st);
      hasError.value = true;
      _allBookings.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      isLoadingSaved.value = false;
      savedTrips.value = [];
      return;
    }
    isLoadingSaved.value = true;
    hasSavedError.value = false;
    try {
      savedTrips.value = await FavoritesService.getFavoriteTrips(uid);
      _savedLoadedOnce = true;
    } catch (e, st) {
      print('MyBookingsController.fetchSaved ERROR: $e');
      // ignore: avoid_print
      print(st);
      hasSavedError.value = true;
      savedTrips.value = [];
    } finally {
      isLoadingSaved.value = false;
    }
  }

  Future<void> refresh() {
    if (selectedTab.value == BookingTab.saved) return fetchSaved();
    return fetchBookings();
  }

  void selectTab(BookingTab tab) {
    selectedTab.value = tab;
    // Lazy-load Saved trips only the first time that tab is opened.
    if (tab == BookingTab.saved && !_savedLoadedOnce) {
      fetchSaved();
    }
  }

  List<BookingModel> get filteredBookings {
    switch (selectedTab.value) {
      case BookingTab.cancelled:
        return _allBookings.where((b) => b.isCancelled).toList();
      case BookingTab.completed:
        return _allBookings.where((b) => b.isCompleted).toList()
          ..sort((a, b) => b.selectedDate.compareTo(a.selectedDate));
      case BookingTab.upcoming:
        return _allBookings.where((b) => b.isUpcoming).toList()
          ..sort((a, b) => a.selectedDate.compareTo(b.selectedDate));
      case BookingTab.saved:
        return const [];
    }
  }

  int countFor(BookingTab tab) {
    switch (tab) {
      case BookingTab.cancelled:
        return _allBookings.where((b) => b.isCancelled).length;
      case BookingTab.completed:
        return _allBookings.where((b) => b.isCompleted).length;
      case BookingTab.upcoming:
        return _allBookings.where((b) => b.isUpcoming).length;
      case BookingTab.saved:
        return savedTrips.length;
    }
  }

  /// "Next Trip" / "In 5 Days" / "In 1 Month" jaisa relative label
  String relativeLabel(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (diff <= 0) return 'Today';
    if (diff <= 2) return 'Next Trip';
    if (diff < 30) return 'In $diff Days';
    final months = (diff / 30).round();
    return 'In $months Month${months > 1 ? 's' : ''}';
  }

  final RxBool isCancelling = false.obs;

  Future<bool> cancelBooking(String bookingId) async {
    isCancelling.value = true;
    try {
      await BookingService.cancelBooking(bookingId);
      await fetchBookings();
      return true;
    } catch (_) {
      return false;
    } finally {
      isCancelling.value = false;
    }
  }

  Future<void> toggleSaved(String tripId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FavoritesService.toggleFavorite(uid: uid, tripId: tripId);
    await fetchSaved();
  }
}