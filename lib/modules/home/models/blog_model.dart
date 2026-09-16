import 'package:cloud_firestore/cloud_firestore.dart';

class BlogSection {
  final String heading;
  final String description;
  final String image;

  BlogSection({required this.heading, required this.description, this.image = ''});

  factory BlogSection.fromMap(Map<String, dynamic> map) => BlogSection(
    heading: map['heading'] ?? '',
    description: map['description'] ?? '',
    image: map['image'] ?? '',
  );
}

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
  final String introText;
  final List<BlogSection> sections;

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
    this.introText = '',
    this.sections = const [],
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
      introText: data['introText'] ?? '',
      sections: (data['sections'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((m) => BlogSection.fromMap(m))
          .toList(),
    );
  }
}