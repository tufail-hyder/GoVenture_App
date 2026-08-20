import 'package:cloud_firestore/cloud_firestore.dart';

class ItineraryDay {
  final int day;
  final String title;
  final String description;

  ItineraryDay({required this.day, required this.title, required this.description});

  factory ItineraryDay.fromMap(Map<String, dynamic> map) => ItineraryDay(
    day: _asInt(map['day']),
    title: map['title'] ?? '',
    description: map['description'] ?? '',
  );

  Map<String, dynamic> toMap() => {'day': day, 'title': title, 'description': description};
}
double _asDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.trim()) ?? fallback;
  return fallback;
}
double? _asDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.trim());
  return null;
}
int _asInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim()) ?? fallback;
  return fallback;
}
class TripModel {
  final String id;
  final String title;
  final String slug;
  final String location;
  final double price;
  final double? originalPrice;
  final int duration;
  final String type;
  final String coverImage;
  final List<String> gallery;
  final String shortDescription;
  final List<ItineraryDay> itinerary;
  final List<String> inclusions;
  final List<String> exclusions;
  final String mapEmbedUrl;
  final bool isFeatured;
  final bool isActive;
  final int viewCount;
  final int bookingsCount;
  final int reviewCount;
  final double rating;
  final String tourMode;
  final bool hasTransfers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isTopExperience;
  final String experienceTag;
  final List<String> highlights;
  final String itineraryPdfUrl;
  final String meetingPoint;
  final double? latitude;
  final double? longitude;
  final List<DateTime> availableDates;
  final int? totalSeats;
  final int? bookedSeats;

  TripModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.location,
    required this.price,
    this.originalPrice,
    required this.duration,
    required this.type,
    required this.coverImage,
    required this.gallery,
    required this.shortDescription,
    required this.itinerary,
    required this.inclusions,
    required this.exclusions,
    required this.mapEmbedUrl,
    required this.isFeatured,
    required this.isActive,
    this.viewCount = 0,
    this.bookingsCount = 0,
    this.reviewCount = 0,
    this.rating = 0.0,
    this.tourMode = 'group',
    this.hasTransfers = false,
    this.createdAt,
    this.updatedAt,
    this.isTopExperience = false,
    this.experienceTag = '',
    this.highlights = const [],
    this.itineraryPdfUrl = '',
    this.meetingPoint = '',
    this.latitude,
    this.longitude,
    this.availableDates = const [],
    this.totalSeats,
    this.bookedSeats,
  });

  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripModel(
      id: doc.id,
      title: data['title'] ?? '',
      slug: data['slug'] ?? '',
      location: data['location'] ?? '',
      price: _asDouble(data['price']),
      originalPrice: _asDoubleOrNull(data['originalPrice']),
      duration: _asInt(data['duration']),
      type: data['type'] ?? '',
      coverImage: data['coverImage'] ?? '',
      gallery: List<String>.from(data['gallery'] ?? []),
      shortDescription: data['shortDescription'] ?? '',
      itinerary: (data['itinerary'] as List<dynamic>? ?? [])
          .map((e) => ItineraryDay.fromMap(e as Map<String, dynamic>))
          .toList(),
      inclusions: List<String>.from(data['inclusions'] ?? []),
      exclusions: List<String>.from(data['exclusions'] ?? []),
      mapEmbedUrl: data['mapEmbedUrl'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      isActive: data['isActive'] ?? false,
      viewCount: _asInt(data['viewCount']),
      bookingsCount: _asInt(data['bookingsCount']),
      reviewCount: _asInt(data['reviewCount']),
      rating: _asDouble(data['rating']),
      tourMode: data['tourMode'] ?? 'group',
      hasTransfers: data['hasTransfers'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isTopExperience: data['isTopExperience'] ?? false,
      experienceTag: data['experienceTag'] ?? '',
      highlights: List<String>.from(data['highlights'] ?? []),
      itineraryPdfUrl: data['itineraryPdfUrl'] ?? '',
      meetingPoint: data['meetingPoint'] ?? '',
      latitude: _asDoubleOrNull(data['latitude']),
      longitude: _asDoubleOrNull(data['longitude']),
      availableDates: (data['availableDates'] as List<dynamic>? ?? [])
          .map((t) => (t as Timestamp).toDate())
          .toList(),
      totalSeats: data['totalSeats'],
      bookedSeats: data['bookedSeats'],
    );
  }
  int? get remainingSeats {
    if (totalSeats == null) return null;
    return totalSeats! - (bookedSeats ?? 0);
  }
}