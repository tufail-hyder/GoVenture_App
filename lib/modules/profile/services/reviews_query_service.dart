import 'package:cloud_firestore/cloud_firestore.dart';
import '../../tripdetails/models/review_model.dart';

class UserReviewEntry {
  final String tripId;
  final String tripTitle;
  final ReviewModel review;
  UserReviewEntry({required this.tripId, required this.tripTitle, required this.review});
}

class ReviewsQueryService {
  static Future<List<UserReviewEntry>> getUserReviews(String uid) async {
    final snap = await FirebaseFirestore.instance
        .collectionGroup('reviews')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs.map((doc) {
      final review = ReviewModel.fromFirestore(doc);
      final tripDoc = doc.reference.parent.parent;
      return UserReviewEntry(
        tripId: tripDoc?.id ?? '',
        tripTitle: doc.data()['tripTitle'] ?? '',
        review: review,
      );
    }).toList();
  }
}