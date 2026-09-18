import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_text.dart';
import '../modules/mybookings/models/upcoming_booking_model.dart';
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
        .get();

    final bookings = snap.docs.map((d) => BookingModel.fromFirestore(d)).toList();
    bookings.sort((a, b) {
      final aDate = a.createdAt ?? DateTime(2000);
      final bDate = b.createdAt ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
    return bookings;
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