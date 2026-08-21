import 'package:cloud_firestore/cloud_firestore.dart';

class CustomTourRequestModel {
  final String? id;

  // ---- Where do you want to go? ----
  final String location;
  final String? tourUrl;

  // ---- Arrangements requested (multi-select) ----
  final List<String> arrangements;

  // ---- Trip details ----
  final String? groupSize;
  final String? groupDetails;
  final int? numberOfDays;
  final int? numberOfRooms;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startLocation;
  final String? endLocation;

  // ---- Preferences ----
  final String? accommodationPreference;
  final String? transportPreference;
  final String? mealsPreference;
  final String? activitiesPreference;
  final String? guidePreference;
  final String? specialRequirements;

  // ---- Budget ----
  final double? budgetPerPerson;
  final String currency;

  // ---- Contact details ----
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String nationality;

  final String? otherDetails;
  final DateTime? createdAt;
  final String status; // pending | contacted | closed

  CustomTourRequestModel({
    this.id,
    required this.location,
    this.tourUrl,
    this.arrangements = const [],
    this.groupSize,
    this.groupDetails,
    this.numberOfDays,
    this.numberOfRooms,
    this.startDate,
    this.endDate,
    this.startLocation,
    this.endLocation,
    this.accommodationPreference,
    this.transportPreference,
    this.mealsPreference,
    this.activitiesPreference,
    this.guidePreference,
    this.specialRequirements,
    this.budgetPerPerson,
    this.currency = 'PKR',
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.nationality,
    this.otherDetails,
    this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'tourUrl': tourUrl,
      'arrangements': arrangements,
      'groupSize': groupSize,
      'groupDetails': groupDetails,
      'numberOfDays': numberOfDays,
      'numberOfRooms': numberOfRooms,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'accommodationPreference': accommodationPreference,
      'transportPreference': transportPreference,
      'mealsPreference': mealsPreference,
      'activitiesPreference': activitiesPreference,
      'guidePreference': guidePreference,
      'specialRequirements': specialRequirements,
      'budgetPerPerson': budgetPerPerson,
      'currency': currency,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'nationality': nationality,
      'otherDetails': otherDetails,
      'createdAt': FieldValue.serverTimestamp(),
      'status': status,
    };
  }

  factory CustomTourRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CustomTourRequestModel(
      id: doc.id,
      location: data['location'] ?? '',
      tourUrl: data['tourUrl'],
      arrangements: List<String>.from(data['arrangements'] ?? []),
      groupSize: data['groupSize'],
      groupDetails: data['groupDetails'],
      numberOfDays: data['numberOfDays'],
      numberOfRooms: data['numberOfRooms'],
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      startLocation: data['startLocation'],
      endLocation: data['endLocation'],
      accommodationPreference: data['accommodationPreference'],
      transportPreference: data['transportPreference'],
      mealsPreference: data['mealsPreference'],
      activitiesPreference: data['activitiesPreference'],
      guidePreference: data['guidePreference'],
      specialRequirements: data['specialRequirements'],
      budgetPerPerson: (data['budgetPerPerson'] as num?)?.toDouble(),
      currency: data['currency'] ?? 'PKR',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      nationality: data['nationality'] ?? '',
      otherDetails: data['otherDetails'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      status: data['status'] ?? 'pending',
    );
  }
}