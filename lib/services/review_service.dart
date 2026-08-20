import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

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
}