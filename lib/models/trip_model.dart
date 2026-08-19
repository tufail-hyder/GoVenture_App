import 'package:cloud_firestore/cloud_firestore.dart';

class ItineraryDay {
  final int day;
  final String title;
  final String description;

  ItineraryDay({required this.day, required this.title, required this.description});

  factory ItineraryDay.fromMap(Map<String, dynamic> map) => ItineraryDay(
    day: map['day'] ?? 0,
    title: map['title'] ?? '',
    description: map['description'] ?? '',
  );

  Map<String, dynamic> toMap() => {'day': day, 'title': title, 'description': description};
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
  });

  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripModel(
      id: doc.id,
      title: data['title'] ?? '',
      slug: data['slug'] ?? '',
      location: data['location'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      originalPrice: data['originalPrice'] != null
          ? (data['originalPrice'] as num).toDouble()
          : null,
      duration: data['duration'] ?? 0,
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
      viewCount: data['viewCount'] ?? 0,
      bookingsCount: data['bookingsCount'] ?? 0,
      reviewCount: data['reviewCount'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      tourMode: data['tourMode'] ?? 'group',
      hasTransfers: data['hasTransfers'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isTopExperience: data['isTopExperience'] ?? false,
      experienceTag: data['experienceTag'] ?? '',
    );
  }
}