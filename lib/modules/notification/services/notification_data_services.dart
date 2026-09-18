import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notification_model.dart';

class NotificationDataService {
  static final _col = FirebaseFirestore.instance.collection('notifications');

  static Future<List<NotificationModel>> getRecent({int limit = 50}) async {
    final snap = await _col
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(NotificationModel.fromDoc).toList();
  }
}