import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/cloudinary_utils.dart';

class CardImage extends StatelessWidget {
  const CardImage({super.key, required this.coverImage});

  final String coverImage;

  bool get _isNetwork => coverImage.startsWith('http://') || coverImage.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (coverImage.isEmpty) return _placeholder();

    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: optimizedCloudinaryUrl(coverImage, width: 300),
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (context, url) => _placeholder(loading: true),
        errorWidget: (context, url, error) => _placeholder(broken: true),
      );
    }

    return Image.asset(
      coverImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _placeholder(broken: true),
    );
  }

  Widget _placeholder({bool loading = false, bool broken = false}) {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(broken ? Icons.broken_image_outlined : Icons.image_outlined, color: Colors.grey.shade500),
    );
  }
}