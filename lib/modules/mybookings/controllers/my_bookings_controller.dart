import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../booking/models/booking_model.dart';
import '../../../services/booking_service.dart';

enum BookingTab { upcoming, completed, cancelled }

class MyBookingsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<BookingModel> _allBookings = <BookingModel>[].obs;
  final Rx<BookingTab> selectedTab = BookingTab.upcoming.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    try {
      _allBookings.value = await BookingService.getUserBookings(uid);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => fetchBookings();

  void selectTab(BookingTab tab) => selectedTab.value = tab;

  List<BookingModel> get filteredBookings {
    final now = DateTime.now();
    switch (selectedTab.value) {
      case BookingTab.cancelled:
        return _allBookings.where((b) => b.bookingStatus == 'cancelled').toList();
      case BookingTab.completed:
        return _allBookings
            .where((b) => b.bookingStatus != 'cancelled' && b.selectedDate.isBefore(now))
            .toList();
      case BookingTab.upcoming:
        return _allBookings
            .where((b) => b.bookingStatus != 'cancelled' && !b.selectedDate.isBefore(now))
            .toList()
          ..sort((a, b) => a.selectedDate.compareTo(b.selectedDate));
    }
  }

  int countFor(BookingTab tab) {
    final now = DateTime.now();
    switch (tab) {
      case BookingTab.cancelled:
        return _allBookings.where((b) => b.bookingStatus == 'cancelled').length;
      case BookingTab.completed:
        return _allBookings.where((b) => b.bookingStatus != 'cancelled' && b.selectedDate.isBefore(now)).length;
      case BookingTab.upcoming:
        return _allBookings.where((b) => b.bookingStatus != 'cancelled' && !b.selectedDate.isBefore(now)).length;
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
}