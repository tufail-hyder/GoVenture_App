import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_text.dart';

class HomeHeroHeader extends StatelessWidget {
  final String greeting;
  final VoidCallback onFilterTap;
  final ValueChanged<String>? onSearchSubmitted;

  const HomeHeroHeader({
    super.key,
    required this.greeting,
    required this.onFilterTap,
    this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          child: SizedBox(
            height: 240,
            width: double.infinity,
            child: Image.asset(AppImages.homeHeaderBg, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: AppSizes.xxl + AppSizes.sm,
          left: AppSizes.md,
          right: AppSizes.md,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppImages.appLightLogo, width: 120, height: 40),
                  Text(
                    AppTexts.appTagline,
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(Icons.notifications_none_rounded, color: theme.iconTheme.color),
                  ),
                  Positioned(
                    top: -2, right: -2,
                    child: Container(
                      width: 10, height: 10,
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Text(AppTexts.appTagline, style: theme.textTheme.labelSmall?.copyWith(color: Colors.black)),

        Positioned(
          top: 140, left: AppSizes.md, right: AppSizes.md,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 26, color: Colors.black),
                  children: [
                    const TextSpan(text: 'Explore the Pakistan\nwith '),
                    TextSpan(text: 'GoVenture', style: const TextStyle(color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -26, left: AppSizes.md, right: AppSizes.md,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            child: TextField(
              onSubmitted: onSearchSubmitted,
              decoration: InputDecoration(
                hintText: 'Search destinations, trips...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                  onPressed: onFilterTap,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}