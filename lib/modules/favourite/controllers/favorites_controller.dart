import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goventure/modules/favourite/services/favourite_services.dart';
class FavoritesController extends GetxController {
  final RxSet<String> tripIds = <String>{}.obs;
  final RxBool isLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
    FirebaseAuth.instance.authStateChanges().listen((_) => _loadFavorites());
  }

  Future<void> _loadFavorites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      tripIds.clear();
      isLoaded.value = true;
      return;
    }
    try {
      final ids = await FavoritesService.getFavoriteTripIds(uid);
      tripIds.value = ids.toSet();
    } catch (e) {
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

  bool isFavorite(String tripId) => tripIds.contains(tripId);

  Future<void> toggle(String tripId) async {
    final wasFavorite = tripIds.contains(tripId);
    // ===== Optimistic update — turant har jagah reflect ho =====
    if (wasFavorite) {
      tripIds.remove(tripId);
    } else {
      tripIds.add(tripId);
    }

    final uid = await _ensureUid();
    if (uid == null) return;

    try {
      await FavoritesService.toggleFavorite(uid: uid, tripId: tripId);
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
}