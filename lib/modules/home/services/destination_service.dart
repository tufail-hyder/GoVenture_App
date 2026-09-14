import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/destination_model.dart';

class DestinationService {
  static final _col = FirebaseFirestore.instance.collection('destinations');

  static Future<List<DestinationModel>> getPopularDestinations({int limit = 10}) async {
    final snap = await _col.orderBy('order', descending: false).limit(limit).get();
    return snap.docs.map((d) => DestinationModel.fromMap(d.id, d.data())).toList();
  }

  static Future<DestinationModel?> getDestinationById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return DestinationModel.fromMap(doc.id, doc.data()!);
  }

  static Stream<DestinationModel?> watchDestination(String id) {
    return _col.doc(id).snapshots().map(
          (doc) => doc.exists ? DestinationModel.fromMap(doc.id, doc.data()!) : null,
    );
  }
}