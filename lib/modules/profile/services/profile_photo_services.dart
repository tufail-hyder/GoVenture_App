import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';

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

    if (source == ImageSource.camera) {
      final granted = await _ensureCameraPermission(context);
      if (!granted) return null;
    }
    // Gallery: Android par koi runtime permission nahi chahiye (system
    // photo picker sandboxed hota hai). iOS par image_picker khud
    // Info.plist ke NSPhotoLibraryUsageDescription se native prompt dikhata
    // hai — is liye yahan Permission.photos ki zaroorat nahi.

    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked == null) return null; // user ne picker cancel kar diya

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
    } catch (e, st) {
      debugPrint('Profile photo update failed: $e');
      debugPrint('$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          // ===== TEMPORARY: asal error dikha raha hai taake diagnose ho sake.
          // Jab masla theek ho jaye to is line ko wapas generic message se
          // replace kar dein: 'Could not update profile picture. Please try again.'
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
      return null;
    }
  }

  static Future<bool> _ensureCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;

    if (status.isPermanentlyDenied) {
      if (context.mounted) await _showSettingsDialog(context, 'Camera');
      return false;
    }

    status = await Permission.camera.request();

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (context.mounted) await _showSettingsDialog(context, 'Camera');
      return false;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is needed to take a photo.')),
      );
    }
    return false;
  }

  static Future<void> _showSettingsDialog(BuildContext context, String feature) {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text('$feature access is disabled. Please enable it from Settings.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}