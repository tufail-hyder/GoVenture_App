import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_text.dart';
import '../models/upcoming_booking_model.dart';

class BookingService {
  static final CollectionReference _bookingsRef =
  FirebaseFirestore.instance.collection(AppTexts.colBookings);

  static Future<List<UpcomingBookingModel>> getUpcomingBookings(String uid, {int limit = 5}) async {
    final snap = await _bookingsRef
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: AppTexts.bookingUpcoming)
        .orderBy('travelDate')
        .limit(limit)
        .get();
    return snap.docs.map((d) => UpcomingBookingModel.fromFirestore(d)).toList();
  }
}