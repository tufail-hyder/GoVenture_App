import 'package:cloud_firestore/cloud_firestore.dart';
import '../../tripdetails/models/trip_terms_model.dart';

class TermsService {
  static Future<TermsModel> _getDoc(String docId) async {
    final doc = await FirebaseFirestore.instance.collection('appSettings').doc(docId).get();
    if (!doc.exists) return TermsModel.empty();
    return TermsModel.fromFirestore(doc);
  }

  static Future<TermsModel> getTripTerms() => _getDoc('tripTerms');
  static Future<TermsModel> getPrivacyPolicy() => _getDoc('privacyPolicy');
}