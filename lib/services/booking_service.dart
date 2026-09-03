import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_text.dart';
import '../models/upcoming_booking_model.dart';
import '../modules/booking/models/booking_model.dart';

class BookingService {
  static final CollectionReference _bookingsRef =
  FirebaseFirestore.instance.collection(AppTexts.colBookings);

  // ===== Booking Creation & Fetch =====
  static Future<String> createPendingBooking(BookingModel booking) async {
    final doc = await _bookingsRef.add(booking.toFirestore());
    return doc.id;
  }

  static Future<BookingModel?> getBooking(String bookingId) async {
    final doc = await _bookingsRef.doc(bookingId).get();
    if (!doc.exists) return null;
    return BookingModel.fromFirestore(doc);
  }

  static Stream<BookingModel?> watchBooking(String bookingId) {
    return _bookingsRef.doc(bookingId).snapshots().map(
          (doc) => doc.exists ? BookingModel.fromFirestore(doc) : null,
    );
  }

  static Future<List<BookingModel>> getUserBookings(String uid) async {
    final snap = await _bookingsRef
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => BookingModel.fromFirestore(d)).toList();
  }

  // ===== Home Screen "Upcoming Trips" =====
  static Future<List<UpcomingBookingModel>> getUpcomingBookings(String uid, {int limit = 5}) async {
    final snap = await _bookingsRef
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: AppTexts.bookingUpcoming)
        .orderBy('travelDate')
        .limit(limit)
        .get();
    return snap.docs.map((d) => UpcomingBookingModel.fromFirestore(d)).toList();
  }

  // ===== Payment Method Update  =====
  static Future<void> updatePaymentMethod({
    required String bookingId,
    required String method,
  }) async {
    await _bookingsRef.doc(bookingId).update({'paymentMethod': method});
  }

  static Future<void> cancelBooking(String bookingId) async {
    await _bookingsRef.doc(bookingId).update({
      'bookingStatus': 'cancelled',
      'status': 'cancelled',
    });
  }

  static Future<List<BookingModel>> streamUserBookingsOnce(String uid) => getUserBookings(uid);
}