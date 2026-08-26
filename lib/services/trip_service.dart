import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_text.dart';
import '../models/trip_model.dart';

class TripService {
  static final CollectionReference _tripsRef =
  FirebaseFirestore.instance.collection(AppTexts.colTrips);
  static Future<List<TripModel>> getAllTrips({int limit = 100}) async {
    final snap = await _tripsRef
        .where('isActive', isEqualTo: true)
        .limit(limit)
        .get();

    final trips = <TripModel>[];
    for (final doc in snap.docs) {
      try {
        trips.add(TripModel.fromFirestore(doc));
      } catch (e) {
        print('⚠️ Skipping malformed trip document [${doc.id}]: $e');
      }
    }
    return trips;
  }

  static Future<List<TripModel>> getFeaturedTrips({int limit = 6}) async {
    final snap = await _tripsRef
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => TripModel.fromFirestore(d)).toList();
  }

  static Future<List<TripModel>> getPopularTrips({int limit = 6}) async {
    final snap = await _tripsRef
        .where('isActive', isEqualTo: true)
        .orderBy('viewCount', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => TripModel.fromFirestore(d)).toList();
  }

  static Future<List<TripModel>> getRecommendedTrips({
    List<String> excludeIds = const [],
    int limit = 6,
  }) async {
    final snap = await _tripsRef
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit + excludeIds.length)
        .get();
    return snap.docs
        .map((d) => TripModel.fromFirestore(d))
        .where((t) => !excludeIds.contains(t.id))
        .take(limit)
        .toList();
  }

  static Future<List<TripModel>> getTripsByType(String type, {int limit = 10}) async {
    final snap = await _tripsRef
        .where('isActive', isEqualTo: true)
        .where('type', isEqualTo: type)
        .limit(limit)
        .get();
    return snap.docs.map((d) => TripModel.fromFirestore(d)).toList();
  }

  static Future<List<TripModel>> getTripsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final snap = await _tripsRef.where(FieldPath.documentId, whereIn: ids).get();
    final trips = snap.docs.map((d) => TripModel.fromFirestore(d)).toList();
    trips.sort((a, b) => ids.indexOf(a.id).compareTo(ids.indexOf(b.id)));
    return trips;
  }

  static Future<TripModel?> getTripById(String tripId) async {
    final doc = await _tripsRef.doc(tripId).get();
    if (!doc.exists) return null;
    return TripModel.fromFirestore(doc);
  }

  static Future<List<TripModel>> getTopExperiences({int limit = 4}) async {
    final snap = await _tripsRef
        .where('isActive', isEqualTo: true)
        .where('isTopExperience', isEqualTo: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => TripModel.fromFirestore(d)).toList();
  }
}