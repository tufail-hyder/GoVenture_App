import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/custom_tour_model.dart';

class CustomTourRequestService {
  static final CollectionReference _requestsRef =
  FirebaseFirestore.instance.collection('customTourRequests');

  static Future<void> submitRequest(CustomTourRequestModel request) async {
    await _requestsRef.add(request.toMap());
  }
}