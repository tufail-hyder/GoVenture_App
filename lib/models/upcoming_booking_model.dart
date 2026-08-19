import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingBookingModel {
  final String id;
  final String tripId;
  final String tripTitle;
  final String tripImage;
  final DateTime? travelDate;
  final String status;
  final int? duration;
  final num? amount;
  final int? travelers;   // NAYA — Booking Form (Step 9) mein set hoga

  UpcomingBookingModel({
    required this.id,
    required this.tripId,
    required this.tripTitle,
    required this.tripImage,
    required this.travelDate,
    required this.status,
    this.duration,
    this.amount,
    this.travelers,
  });

  factory UpcomingBookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UpcomingBookingModel(
      id: doc.id,
      tripId: data['tripId'] ?? '',
      tripTitle: data['tripTitle'] ?? '',
      tripImage: data['tripImage'] ?? '',
      travelDate: (data['travelDate'] as Timestamp?)?.toDate(),
      status: data['status'] ?? '',
      duration: data['duration'],
      amount: data['amount'],
      travelers: data['travelers'],
    );
  }
}