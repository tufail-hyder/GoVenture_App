import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/support_contact_model.dart';


class SupportContactService {
  static SupportContactModel? _cached;

  static Future<SupportContactModel> getSupportContact() async {
    if (_cached != null) return _cached!;

    final doc = await FirebaseFirestore.instance
        .collection('appSettings')
        .doc('supportContact')
        .get();

    final result = doc.exists ? SupportContactModel.fromFirestore(doc) : SupportContactModel.empty();
    _cached = result;
    return result;
  }
}