import 'package:get_storage/get_storage.dart';

class RecentlyViewedService {
  static const _key = 'recently_viewed_trip_ids';
  static const _maxItems = 10;
  static final _box = GetStorage();

  static List<String> getIds() {
    final raw = _box.read<List>(_key) ?? [];
    return raw.cast<String>();
  }

  /// Trip detail screen open hote hi ye call karna hai (Step 7 mein add karenge)
  static Future<void> addTripId(String tripId) async {
    final ids = getIds();
    ids.remove(tripId);       // duplicate hatao
    ids.insert(0, tripId);    // sab se aage rakho (most recent)
    if (ids.length > _maxItems) ids.removeRange(_maxItems, ids.length);
    await _box.write(_key, ids);
  }
}