import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../booking/models/booking_model.dart';

class MyTripsController extends GetxController {
  final RxList<BookingModel> upcoming = <BookingModel>[].obs;
  final RxList<BookingModel> completed = <BookingModel>[].obs;
  final RxList<BookingModel> cancelled = <BookingModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToBookings();
  }

  void _listenToBookings() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }

    FirebaseFirestore.instance
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .orderBy('selectedDate')
        .snapshots()
        .listen((snapshot) {
      final all = snapshot.docs.map((d) => BookingModel.fromFirestore(d)).toList();

      final now = DateTime.now();
      upcoming.value = all.where((b) =>
      b.bookingStatus != 'cancelled' &&
          b.selectedDate.isAfter(now)).toList();
      completed.value = all.where((b) =>
      b.bookingStatus != 'cancelled' &&
          b.selectedDate.isBefore(now)).toList();
      cancelled.value = all.where((b) => b.bookingStatus == 'cancelled').toList();

      isLoading.value = false;
    }, onError: (_) {
      isLoading.value = false;
    });
  }


  String badgeFor(DateTime date) {
    final days = date.difference(DateTime.now()).inDays;
    if (days <= 3) return 'Next Trip';
    if (days <= 45) return 'In $days Days';
    final months = (days / 30).round();
    return 'In $months Month${months > 1 ? 's' : ''}';//
  }
}