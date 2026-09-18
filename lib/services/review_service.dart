import 'package:cloud_firestore/cloud_firestore.dart';
import '../modules/tripdetails/models/review_model.dart';

class ReviewService {
  static Future<List<ReviewModel>> getReviewsForTrip(String tripId, {int limit = 20}) async {
    final snap = await FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => ReviewModel.fromFirestore(d)).toList();
  }

  static Future<void> addReview({
    required String tripId,
    required String userId,
    required String userName,
    required String userPhoto,
    required double rating,
    required String comment,
  }) async {
    final review = ReviewModel(
      id: '', // ignored — Firestore assigns the real id on add()
      userId: userId,
      userName: userName,
      userPhoto: userPhoto,
      rating: rating,
      comment: comment,
    );
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .collection('reviews')
        .add(review.toMap());
  }

  /// Updates the rating/comment of an existing review. `createdAt` is left
  /// untouched — only the content changes.
  static Future<void> updateReview({
    required String tripId,
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .collection('reviews')
        .doc(reviewId)
        .update({'rating': rating, 'comment': comment});
  }

  static Future<void> deleteReview({
    required String tripId,
    required String reviewId,
  }) async {
    await FirebaseFirestore.instance
        .collection('trips')
        .doc(tripId)
        .collection('reviews')
        .doc(reviewId)
        .delete();
  }
}