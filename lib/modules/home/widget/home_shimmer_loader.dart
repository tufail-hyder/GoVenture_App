import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../core/constants/app_sizes.dart';

class HomeShimmerLoader extends StatelessWidget {
  const HomeShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).cardColor;

    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(milliseconds: 500),
      color: Colors.white,
      colorOpacity: 0.3,
      enabled: true,
      direction: const ShimmerDirection.fromLeftToRight(),
      child: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _box(
            height: 40,
            width: 150,
            color: baseColor,
          ),

          const SizedBox(height: AppSizes.lg),

          _box(
            height: 60,
            width: double.infinity,
            color: baseColor,
          ),

          const SizedBox(height: AppSizes.lg),

          _box(
            height: 150,
            width: double.infinity,
            radius: AppSizes.radiusLg,
            color: baseColor,
          ),

          const SizedBox(height: AppSizes.lg),

          _sectionTitle(baseColor),

          const SizedBox(height: AppSizes.sm),

          _horizontalCards(baseColor),

          const SizedBox(height: AppSizes.lg),

          _sectionTitle(baseColor),

          const SizedBox(height: AppSizes.sm),

          _horizontalCards(baseColor),
        ],
      ),
    );
  }

  Widget _box({
    required double height,
    required double width,
    required Color color,
    double radius = AppSizes.radiusMd,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _sectionTitle(Color color) {
    return _box(
      height: 20,
      width: 140,
      color: color,
    );
  }

  Widget _horizontalCards(Color color) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(
          width: AppSizes.sm,
        ),
        itemBuilder: (_, __) {
          return _box(
            height: 180,
            width: 150,
            radius: AppSizes.radiusLg,
            color: color,
          );
        },
      ),
    );
  }
}