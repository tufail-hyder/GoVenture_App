import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id;
  final String title;
  final String slug;
  final String coverImage;
  final String category;
  final String excerpt;
  final bool isPublished;
  final DateTime? publishedAt;
  final int readTimeMinutes;

  BlogModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.coverImage,
    required this.category,
    required this.excerpt,
    required this.isPublished,
    this.publishedAt,
    this.readTimeMinutes = 0,
  });

  factory BlogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BlogModel(
      id: doc.id,
      title: data['title'] ?? '',
      slug: data['slug'] ?? '',
      coverImage: data['coverImage'] ?? '',
      category: data['category'] ?? '',
      excerpt: data['excerpt'] ?? '',
      isPublished: data['isPublished'] ?? false,
      publishedAt: (data['publishedAt'] as Timestamp?)?.toDate(),
      readTimeMinutes: (data['readTimeMinutes'] as num?)?.toInt() ?? 0,
    );
  }
}