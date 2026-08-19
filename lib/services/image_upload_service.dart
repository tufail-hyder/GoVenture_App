import 'package:cloudinary_public/cloudinary_public.dart';

class ImageUploadService {
  static const _cloudName = 'YOUR_CLOUD_NAME';
  static const _uploadPreset = 'goventure_uploads';
  static const _allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const _maxFileSizeBytes = 5 * 1024 * 1024;

  static final _cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);

  static String? _validateFile(String fileName, int fileSizeBytes) {
    final ext = fileName.split('.').last.toLowerCase();
    if (!_allowedExtensions.contains(ext)) {
      return 'Only JPG, PNG, or WEBP images are allowed.';
    }
    if (fileSizeBytes > _maxFileSizeBytes) {
      return 'Image size must be under 5MB.';
    }
    return null;
  }

  static Future<String?> uploadImageBytes(
      List<int> bytes, {
        required String fileName,
        String folder = 'trips',
      }) async {
    final error = _validateFile(fileName, bytes.length);
    if (error != null) {
      throw Exception(error);
    }

    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          bytes,
          identifier: fileName,
          resourceType: CloudinaryResourceType.Image,
          folder: 'goventure/$folder',
        ),
      );
      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }
}