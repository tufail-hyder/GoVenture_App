import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../models/banner_model.dart';

class SeasonalBannerStrip extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback onCtaTap;
  final VoidCallback? onClose;

  const SeasonalBannerStrip({
    super.key,
    required this.banner,
    required this.onCtaTap,
    this.onClose,
  });

  Color _hexToColor(String hex, Color fallback) {
    try {
      final cleaned = hex.replaceAll('#', '');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _hexToColor(banner.backgroundColorHex, const Color(0xFFEAF7EE));
    final accentColor = _hexToColor(banner.accentColorHex, const Color(0xFF1F7A4D));

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg + 4),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [bgColor, bgColor.withValues(alpha: 0.0)],
            stops: const [0.0, 0.7],
          ),
        ),
        child: Stack(
          children: [
            // ===== Base background color (so nothing shows through where image fades out) =====
            Positioned.fill(child: Container(color: bgColor)),

            // ===== Right side image, softly faded on its left edge =====
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.72,
                  heightFactor: 1,
                  child: ShaderMask(
                    shaderCallback: (rect) => LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: const [
                        Colors.transparent,
                        Colors.white,
                      ],
                      stops: const [0.0, 0.55],
                    ).createShader(rect),
                    blendMode: BlendMode.dstIn,
                    child: banner.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: banner.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: bgColor),
                      errorWidget: (_, __, ___) => Container(color: bgColor),
                    )
                        : Container(color: bgColor),
                  ),
                ),
              ),
            ),

            // ===== Text + CTA (left side) =====
            Positioned(
              left: AppSizes.md,
              top: AppSizes.sm + 4,
              bottom: AppSizes.sm + 4,
              right: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(banner.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          banner.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    banner.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.65),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm + 2),
                  GestureDetector(
                    onTap: onCtaTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(
                        banner.ctaText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== Close button =====
            if (onClose != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 16, color: Colors.black.withValues(alpha: 0.7)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}