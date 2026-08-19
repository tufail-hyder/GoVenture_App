import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final String ctaText;
  final String ctaLink;   // tripId ho sakta hai (internal) ya URL (external)
  final bool isActive;
  final DateTime? startDate;
  final DateTime? endDate;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.ctaText,
    required this.ctaLink,
    required this.isActive,
    this.startDate,
    this.endDate,
  });

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BannerModel(
      id: doc.id,
      imageUrl: data['imageUrl'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      ctaText: data['ctaText'] ?? 'Explore',
      ctaLink: data['ctaLink'] ?? '',
      isActive: data['isActive'] ?? false,
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
    );
  }
}