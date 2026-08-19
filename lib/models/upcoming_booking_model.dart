import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingBookingModel {
  final String id;
  final String tripId;
  final String tripTitle;
  final String tripImage;
  final DateTime? travelDate;
  final String status;
  final int? duration;   // NAYA — days, Booking Form mein set hoga
  final num? amount;     // NAYA — price, Booking Form mein set hoga

  UpcomingBookingModel({
    required this.id,
    required this.tripId,
    required this.tripTitle,
    required this.tripImage,
    required this.travelDate,
    required this.status,
    this.duration,
    this.amount,
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
    );
  }
}