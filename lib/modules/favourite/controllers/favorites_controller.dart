import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../favourite/services/favourite_services.dart';

class FavoritesController extends GetxController {
  final RxSet<String> tripIds = <String>{}.obs;
  final RxSet<String> destinationIds = <String>{}.obs;
  final RxBool isLoaded = false.obs;

  String? _lastUid;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      final newUid = user?.uid;
      if (newUid != _lastUid) {
        _lastUid = newUid;
        _loadFavorites();
      }
    });
  }

  Future<void> _loadFavorites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    _lastUid = uid;
    if (uid == null) {
      tripIds.clear();
      destinationIds.clear();
      isLoaded.value = true;
      return;
    }
    try {
      final ids = await FavoritesService.getFavoriteTripIds(uid);
      tripIds.value = ids.toSet();
      final destIds = await FavoritesService.getFavoriteDestinationIds(uid);
      destinationIds.value = destIds.toSet();
    } catch (e) {
      // ignore: avoid_print
      print('FavoritesController._loadFavorites ERROR: $e');
    } finally {
      isLoaded.value = true;
    }
  }

  Future<String?> _ensureUid() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      try {
        final credential = await FirebaseAuth.instance.signInAnonymously();
        user = credential.user;
      } catch (_) {
        return null;
      }
    }
    return user?.uid;
  }

  // ===== Trips =====
  bool isFavorite(String tripId) => tripIds.contains(tripId);

  Future<void> toggle(String tripId) async {
    final wasFavorite = tripIds.contains(tripId);
    if (wasFavorite) {
      tripIds.remove(tripId);
    } else {
      tripIds.add(tripId);
    }

    final uid = await _ensureUid();
    if (uid == null) return;

    try {
      if (wasFavorite) {
        await FavoritesService.removeFavorite(uid: uid, tripId: tripId);
      } else {
        await FavoritesService.addFavorite(uid: uid, tripId: tripId);
      }
    } catch (e) {
      // ignore: avoid_print
      print('FavoritesController.toggle ERROR: $e');
      if (wasFavorite) {
        tripIds.add(tripId);
      } else {
        tripIds.remove(tripId);
      }
    }
  }

  // ===== Destinations =====
  bool isFavoriteDestination(String destinationId) => destinationIds.contains(destinationId);

  Future<void> toggleDestination(String destinationId) async {
    final wasFavorite = destinationIds.contains(destinationId);
    if (wasFavorite) {
      destinationIds.remove(destinationId);
    } else {
      destinationIds.add(destinationId);
    }

    final uid = await _ensureUid();
    if (uid == null) return;

    try {
      if (wasFavorite) {
        await FavoritesService.removeFavoriteDestination(uid: uid, destinationId: destinationId);
      } else {
        await FavoritesService.addFavoriteDestination(uid: uid, destinationId: destinationId);
      }
    } catch (e) {
      // ignore: avoid_print
      print('FavoritesController.toggleDestination ERROR: $e');
      if (wasFavorite) {
        destinationIds.add(destinationId);
      } else {
        destinationIds.remove(destinationId);
      }
    }
  }
}