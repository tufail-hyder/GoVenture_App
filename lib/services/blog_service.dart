import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants/app_text.dart';
import '../models/blog_model.dart';

class BlogService {
  static final CollectionReference _blogsRef =
  FirebaseFirestore.instance.collection(AppTexts.colBlogs);

  static Future<List<BlogModel>> getLatestBlogs({int limit = 4}) async {
    final snap = await _blogsRef
        .where('isPublished', isEqualTo: true)
        .orderBy('publishedAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => BlogModel.fromFirestore(d)).toList();
  }
}