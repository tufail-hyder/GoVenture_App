import 'package:cloud_firestore/cloud_firestore.dart';

class TripDateSlot {
  final DateTime date;
  final int? totalSeats;
  final int? bookedSeats;

  TripDateSlot({required this.date, this.totalSeats, this.bookedSeats});

  factory TripDateSlot.fromMap(Map<String, dynamic> map) {
    return TripDateSlot(
      date: (map['date'] as Timestamp).toDate(),
      totalSeats: map['totalSeats'],
      bookedSeats: map['bookedSeats'],
    );
  }

  int? get remainingSeats {
    if (totalSeats == null) return null;
    return totalSeats! - (bookedSeats ?? 0);
  }
}