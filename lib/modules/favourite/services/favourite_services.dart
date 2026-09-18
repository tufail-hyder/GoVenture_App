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

  static Future<void> addFavorite({required String uid, required String tripId}) =>
      _favoritesRef(uid).doc(tripId).set({'addedAt': FieldValue.serverTimestamp()});

  static Future<void> removeFavorite({required String uid, required String tripId}) =>
      _favoritesRef(uid).doc(tripId).delete();

  static Future<List<TripModel>> getFavoriteTrips(String uid) async {
    final tripIds = await getFavoriteTripIds(uid);
    if (tripIds.isEmpty) return [];
    return TripService.getTripsByIds(tripIds);
  }

  static Future<bool> isFavorite(String uid, String tripId) async {
    final doc = await _favoritesRef(uid).doc(tripId).get();
    return doc.exists;
  }

  // ===== Destinations =====
  static Future<List<String>> getFavoriteDestinationIds(String uid) async {
    final snap = await _favoriteDestinationsRef(uid).get();
    return snap.docs.map((d) => d.id).toList();
  }

  static Future<void> addFavoriteDestination({required String uid, required String destinationId}) =>
      _favoriteDestinationsRef(uid).doc(destinationId).set({'addedAt': FieldValue.serverTimestamp()});

  static Future<void> removeFavoriteDestination({required String uid, required String destinationId}) =>
      _favoriteDestinationsRef(uid).doc(destinationId).delete();

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
}