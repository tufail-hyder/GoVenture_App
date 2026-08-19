import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_text.dart';
import '../models/banner_model.dart';

class BannerService {
  static final CollectionReference _bannersRef =
  FirebaseFirestore.instance.collection(AppTexts.colAnnouncements);

  static Future<BannerModel?> getActiveBanner() async {
    final now = DateTime.now();
    final snap = await _bannersRef
        .where('isActive', isEqualTo: true)
        .orderBy('startDate', descending: true)
        .limit(5)
        .get();

    for (final doc in snap.docs) {
      final banner = BannerModel.fromFirestore(doc);
      final withinStart = banner.startDate == null || !now.isBefore(banner.startDate!);
      final withinEnd = banner.endDate == null || !now.isAfter(banner.endDate!);
      if (withinStart && withinEnd) return banner;
    }
    return null;
  }
}