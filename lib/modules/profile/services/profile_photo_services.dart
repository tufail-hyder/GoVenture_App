import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';

/// Shared logic for changing the user's profile picture, used by both
/// ProfileScreen (avatar tap) and EditProfileScreen (change photo button).
///
/// Handles: source picker sheet -> permission request -> image pick ->
/// Firebase Storage upload -> FirebaseAuth + Firestore update.
/// Any failure shows a SnackBar instead of failing silently.
class ProfilePhotoService {
  static Future<String?> pickAndUpload(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusMd)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a Photo'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return null;

    final hasPermission = await _ensurePermission(source);
    if (!hasPermission) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              source == ImageSource.camera
                  ? 'Camera permission is needed to take a photo. Please allow it from Settings.'
                  : 'Photo access is needed to choose a picture. Please allow it from Settings.',
            ),
          ),
        );
      }
      return null;
    }

    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked == null) return null; // user cancelled the picker itself

      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;
      if (uid == null) throw Exception('Not signed in');

      final ref = FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg');
      await ref.putFile(File(picked.path));
      final url = await ref.getDownloadURL();

      await user?.updatePhotoURL(url);
      await FirebaseFirestore.instance
          .collection(AppTexts.colUsers)
          .doc(uid)
          .set({'photoURL': url}, SetOptions(merge: true));

      return url;
    } catch (e) {
      debugPrint('Profile photo update failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update profile picture. Please try again.')),
        );
      }
      return null;
    }
  }

  static Future<bool> _ensurePermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      return status.isGranted;
    }

    // Gallery: Android 13+ uses READ_MEDIA_IMAGES, older Android uses
    // READ_EXTERNAL_STORAGE / storage permission, iOS uses photos.
    final photos = await Permission.photos.request();
    if (photos.isGranted || photos.isLimited) return true;

    final storage = await Permission.storage.request();
    return storage.isGranted;
  }
}