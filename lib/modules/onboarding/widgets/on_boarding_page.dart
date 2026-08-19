import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/app_theme.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.titleLine1,
    required this.titleLine2,
    required this.subTitle,
    required this.icon,
    this.showBrand = false,
  });

  final String image;
  final String titleLine1;
  final String titleLine2;
  final String subTitle;
  final IconData icon;

  final bool showBrand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ---------- Background Image ----------
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: size.height * 0.35,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),

        // ---------- Brand ----------
        if (showBrand)
          Positioned(
            top: MediaQuery.of(context).padding.top +
                AppSizes.xxl +
                AppSizes.md,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  AppImages.appLightLogo,
                  width: size.width * 0.46,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  AppTexts.appTagline,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontSize: AppSizes.fontMd - 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

        // ---------- Bottom Container ----------
        Positioned(
          top: size.height * 0.62,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusCard + 8),
                topRight: Radius.circular(AppTheme.radiusCard + 8),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.xl,
                AppSizes.xl,
                AppSizes.xl,
                AppSizes.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titleLine1,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimaryLight,
                              ),
                            ),
                            Text(
                              titleLine2,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: AppSizes.iconLg + AppSizes.md,
                        height: AppSizes.iconLg + AppSizes.lg,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: AppColors.primary,
                          size: AppSizes.iconMd + 4,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSizes.md),

                  Text(
                    subTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 17,fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}