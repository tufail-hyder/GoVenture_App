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
  final int? travelers;

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

    final adults = (data['adults'] as num?)?.toInt() ?? 0;
    final children = (data['children'] as num?)?.toInt() ?? 0;
    final infants = (data['infants'] as num?)?.toInt() ?? 0;
    final totalTravelers = adults + children + infants;

    return UpcomingBookingModel(
      id: doc.id,
      tripId: data['tripId'] ?? '',
      tripTitle: data['tripTitle'] ?? '',
      tripImage: data['tripCoverImage'] ?? data['tripImage'] ?? '',
      travelDate: (data['travelDate'] as Timestamp?)?.toDate(),
      status: data['status'] ?? '',
      duration: (data['tripDuration'] as num?)?.toInt() ?? (data['duration'] as num?)?.toInt(),
      amount: data['grandTotal'] ?? data['amount'],
      travelers: totalTravelers > 0 ? totalTravelers : null,
    );
  }
}