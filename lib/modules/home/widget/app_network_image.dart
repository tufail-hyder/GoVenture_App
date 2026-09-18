import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/utils/cloudinary_utils.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final int width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext)? errorBuilder;

  const AppNetworkImage({
    super.key,
    required this.url,
    required this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return errorBuilder?.call(context) ?? Container(color: Colors.grey.shade300);
    }
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final optimizedUrl = optimizedCloudinaryUrl(url, width: (width * dpr).round());

    return CachedNetworkImage(
      imageUrl: optimizedUrl,
      fit: fit,
      height: height,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (context, _) => Container(color: Colors.grey.shade300),
      errorWidget: (context, _, __) =>
      errorBuilder?.call(context) ?? Container(color: Colors.grey.shade300, child: const Icon(Icons.image_not_supported_outlined)),
    );
  }
}