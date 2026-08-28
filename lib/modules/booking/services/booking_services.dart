import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  static final CollectionReference _bookingsRef =
  FirebaseFirestore.instance.collection('bookings');

  static Future<String> createPendingBooking(BookingModel booking) async {
    final doc = await _bookingsRef.add(booking.toFirestore());
    return doc.id;
  }

  static Future<BookingModel?> getBooking(String bookingId) async {
    final doc = await _bookingsRef.doc(bookingId).get();
    if (!doc.exists) return null;
    return BookingModel.fromFirestore(doc);
  }

  /// Live updates for the confirmation screen — once a Cloud Function
  /// verifies payment and flips paymentStatus/bookingStatus server-side,
  /// this stream pushes that change to the UI automatically.
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
}

/*
=== Firestore Security Rules needed (add to firestore.rules) ===

match /bookings/{bookingId} {
  allow create: if request.auth != null
    && request.resource.data.userId == request.auth.uid
    && request.resource.data.paymentStatus == 'pending'
    && request.resource.data.bookingStatus == 'pending';

  allow read: if request.auth != null && resource.data.userId == request.auth.uid;

  // No client update/delete at all — only Cloud Functions (Admin SDK)
  // bypass rules and can change paymentStatus/bookingStatus.
  allow update, delete: if false;
}

This is what actually prevents a compromised/modified client from just
setting paymentStatus: 'paid' directly — the write is rejected outright.
*/