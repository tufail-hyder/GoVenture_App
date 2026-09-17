import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/trip_service.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../home/models/destination_model.dart';
import '../../home/services/destination_service.dart';

class FavoritesService {
  static CollectionReference _favoritesRef(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('favorites');

  static CollectionReference _favoriteDestinationsRef(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('favoriteDestinations');

  // ===== Trips =====
  static Future<List<String>> getFavoriteTripIds(String uid) async {
    final snap = await _favoritesRef(uid).get();
    return snap.docs.map((d) => d.id).toList();
  }

  static Future<List<TripModel>> getFavoriteTrips(String uid) async {
    final tripIds = await getFavoriteTripIds(uid);
    if (tripIds.isEmpty) return [];
    return TripService.getTripsByIds(tripIds);
  }

  static Future<bool> isFavorite(String uid, String tripId) async {
    final doc = await _favoritesRef(uid).doc(tripId).get();
    return doc.exists;
  }

  static Future<void> toggleFavorite({required String uid, required String tripId}) async {
    final ref = _favoritesRef(uid).doc(tripId);
    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({'addedAt': FieldValue.serverTimestamp()});
    }
  }

  // ===== Destinations =====
  static Future<List<String>> getFavoriteDestinationIds(String uid) async {
    final snap = await _favoriteDestinationsRef(uid).get();
    return snap.docs.map((d) => d.id).toList();
  }

  static Future<List<DestinationModel>> getFavoriteDestinations(String uid) async {
    final ids = await getFavoriteDestinationIds(uid);
    if (ids.isEmpty) return [];
    final results = await Future.wait(ids.map((id) => DestinationService.getDestinationById(id)));
    return results.whereType<DestinationModel>().toList();
  }

  static Future<bool> isFavoriteDestination(String uid, String destinationId) async {
    final doc = await _favoriteDestinationsRef(uid).doc(destinationId).get();
    return doc.exists;
  }

  static Future<void> toggleFavoriteDestination({required String uid, required String destinationId}) async {
    final ref = _favoriteDestinationsRef(uid).doc(destinationId);
    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set({'addedAt': FieldValue.serverTimestamp()});
    }
  }
}