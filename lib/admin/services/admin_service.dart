import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  static final _adminsRef = FirebaseFirestore.instance.collection('admins');

  static Future<bool> isCurrentUserAdmin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final doc = await _adminsRef.doc(uid).get();
    return doc.exists;
  }
}