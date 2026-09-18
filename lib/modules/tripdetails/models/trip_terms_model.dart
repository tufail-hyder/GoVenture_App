import 'package:cloud_firestore/cloud_firestore.dart';

class TermsModel {
  final String content;
  final DateTime? updatedAt;

  TermsModel({required this.content, this.updatedAt});

  factory TermsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TermsModel(
      content: data['content'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory TermsModel.empty() => TermsModel(content: '');
}