import 'package:cloud_firestore/cloud_firestore.dart';

class SupportContactModel {
  final String email;
  final String phone;
  final String whatsapp;

  const SupportContactModel({
    required this.email,
    required this.phone,
    required this.whatsapp,
  });

  factory SupportContactModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return SupportContactModel(
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      whatsapp: data['whatsapp'] ?? '',
    );
  }

  factory SupportContactModel.empty() => const SupportContactModel(email: '', phone: '', whatsapp: '');
}