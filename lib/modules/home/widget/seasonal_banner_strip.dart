import 'package:flutter/material.dart';
import '../../../core/constants/app_images.dart';
import '../../../models/banner_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class SeasonalBannerStrip extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback onCtaTap;

  const SeasonalBannerStrip({
    super.key,
    required this.banner,
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    const textShadow = [
      Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 1)),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: SizedBox(
        height: 140,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ---- Photo (any image, any colour/brightness) ----
            banner.imageUrl.isNotEmpty ? Image.asset(AppImages.g7,
              fit: BoxFit.fill,
              errorBuilder: (_, _, _) =>
                  Container(color: AppColors.primaryLight),
            )
                : Container(color: AppColors.primaryLight),

            Container(color: Colors.black.withValues(alpha: 0.28)),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.75],
                ),
              ),
            ),

            // ---- Text + CTA ----
            Positioned(
              left: AppSizes.md,
              right: AppSizes.md,
              bottom: AppSizes.sm,
              top: AppSizes.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    banner.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: textShadow,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    banner.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      shadows: textShadow,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: onCtaTap,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm + 4,
                          vertical: 2,
                        ),
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                      ),
                      child: Text(
                        banner.ctaText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}