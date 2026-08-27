import 'package:cloud_firestore/cloud_firestore.dart';

import '../modules/tripdetails/models/trip_terms_model.dart';

class TermsService {
  static Future<TermsModel> getTripTerms() async {
    final doc = await FirebaseFirestore.instance
        .collection('appSettings')
        .doc('tripTerms')
        .get();

    if (!doc.exists) return TermsModel.empty();
    return TermsModel.fromFirestore(doc);
  }
}