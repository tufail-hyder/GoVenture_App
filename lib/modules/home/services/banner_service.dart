import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/banner_model.dart';

class BannerService {
  static final _col = FirebaseFirestore.instance.collection('banners');

  static Future<BannerModel?> getActiveBanner() async {
    try {
      final snap = await _col
          .where('isActive', isEqualTo: true)
          .orderBy('priority', descending: true)
          .limit(5)
          .get();


      for (final doc in snap.docs) {
        final banner = BannerModel.fromMap(doc.id, doc.data());
        if (banner.isCurrentlyValid) return banner;
      }
      return null;
    } catch (e, st) {
      return null;
    }
  }
}