import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String userName;
  final String userPhoto;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.userPhoto,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      userName: data['userName'] ?? 'Traveler',
      userPhoto: data['userPhoto'] ?? '',
      rating: (data['rating'] is num) ? (data['rating'] as num).toDouble() : 0,
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}