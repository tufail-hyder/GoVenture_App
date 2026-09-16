import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String id;
  final String title;
  final String description;
  final String ctaText;
  final String imageUrl;
  final String emoji;
  final String backgroundColorHex;
  final String accentColorHex;
  final bool isActive;
  final int priority;
  final DateTime? startDate;
  final DateTime? endDate;

  BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ctaText,
    required this.imageUrl,
    this.emoji = '🌸',
    this.backgroundColorHex = '#EAF7EE',
    this.accentColorHex = '#1F7A4D',
    this.isActive = true,
    this.priority = 0,
    this.startDate,
    this.endDate,
  });

  factory BannerModel.fromMap(String id, Map<String, dynamic> map) {
    return BannerModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      ctaText: map['ctaText'] ?? 'Explore',
      imageUrl: map['imageUrl'] ?? '',
      emoji: map['emoji'] ?? '🌸',
      backgroundColorHex: map['backgroundColorHex'] ?? '#EAF7EE',
      accentColorHex: map['accentColorHex'] ?? '#1F7A4D',
      isActive: map['isActive'] ?? true,
      priority: (map['priority'] ?? 0) as int,
      startDate: (map['startDate'] as Timestamp?)?.toDate(),
      endDate: (map['endDate'] as Timestamp?)?.toDate(),
    );
  }

  bool get isCurrentlyValid {
    final now = DateTime.now();
    if (startDate != null && now.isBefore(startDate!)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    return isActive;
  }
}