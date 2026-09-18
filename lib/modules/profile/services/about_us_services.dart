import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/about_us_model.dart';

class AboutUsService {
  static AboutUsModel? _cached;

  static Future<AboutUsModel> getAboutUs() async {
    if (_cached != null) return _cached!;

    final doc = await FirebaseFirestore.instance
        .collection('appSettings')
        .doc('aboutUs')
        .get();

    final result = doc.exists ? AboutUsModel.fromFirestore(doc) : AboutUsModel.empty();
    _cached = result;
    return result;
  }
}