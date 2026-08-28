import 'package:cloud_firestore/cloud_firestore.dart';

/// Mirrors Section 11 of the spec.
enum PaymentStatus { pending, processing, paid, failed, refunded, cancelled }

PaymentStatus paymentStatusFromString(String value) {
  return PaymentStatus.values.firstWhere(
        (s) => s.name == value,
    orElse: () => PaymentStatus.pending,
  );
}

class BookingModel {
  final String id;
  final String tripId;
  final String tripTitle;
  final String tripCoverImage;
  final String userId;

  // Customer info
  final String fullName;
  final String email;
  final String phone;
  final String specialRequests;
  final String emergencyContactName;
  final String emergencyContactPhone;

  // Trip selection
  final DateTime selectedDate;
  final int adults;
  final int children;
  final int infants;

  // Price
  final double adultTotal;
  final double childTotal;
  final double taxesAndFees;
  final double grandTotal;
  final String currency;

  // Payment / booking state
  final String? paymentMethod; // 'jazzcash' | 'easypaisa' | 'card'
  final PaymentStatus paymentStatus;
  final String bookingStatus; // 'pending' | 'confirmed' | 'cancelled'
  final DateTime? createdAt;

  const BookingModel({
    required this.id,
    required this.tripId,
    required this.tripTitle,
    required this.tripCoverImage,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.specialRequests,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.selectedDate,
    required this.adults,
    required this.children,
    required this.infants,
    required this.adultTotal,
    required this.childTotal,
    required this.taxesAndFees,
    required this.grandTotal,
    required this.currency,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.bookingStatus,
    required this.createdAt,
  });

  int get totalTravelers => adults + children + infants;

  Map<String, dynamic> toFirestore() {
    return {
      'tripId': tripId,
      'tripTitle': tripTitle,
      'tripCoverImage': tripCoverImage,
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'specialRequests': specialRequests,
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'selectedDate': Timestamp.fromDate(selectedDate),
      'adults': adults,
      'children': children,
      'infants': infants,
      'adultTotal': adultTotal,
      'childTotal': childTotal,
      'taxesAndFees': taxesAndFees,
      'grandTotal': grandTotal,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus.name,
      'bookingStatus': bookingStatus,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      tripId: data['tripId'] ?? '',
      tripTitle: data['tripTitle'] ?? '',
      tripCoverImage: data['tripCoverImage'] ?? '',
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      specialRequests: data['specialRequests'] ?? '',
      emergencyContactName: data['emergencyContactName'] ?? '',
      emergencyContactPhone: data['emergencyContactPhone'] ?? '',
      selectedDate: (data['selectedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      adults: (data['adults'] as num?)?.toInt() ?? 1,
      children: (data['children'] as num?)?.toInt() ?? 0,
      infants: (data['infants'] as num?)?.toInt() ?? 0,
      adultTotal: (data['adultTotal'] as num?)?.toDouble() ?? 0,
      childTotal: (data['childTotal'] as num?)?.toDouble() ?? 0,
      taxesAndFees: (data['taxesAndFees'] as num?)?.toDouble() ?? 0,
      grandTotal: (data['grandTotal'] as num?)?.toDouble() ?? 0,
      currency: data['currency'] ?? 'PKR',
      paymentMethod: data['paymentMethod'],
      paymentStatus: paymentStatusFromString(data['paymentStatus'] ?? 'pending'),
      bookingStatus: data['bookingStatus'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}