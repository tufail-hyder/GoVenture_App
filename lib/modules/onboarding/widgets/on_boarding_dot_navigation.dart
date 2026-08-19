import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/onboarding_contoller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: 130,
      right: 0,
      left: 34,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        count: 3,
        onDotClicked: controller.dotNavigatorClick,
        effect: ExpandingDotsEffect(
          activeDotColor: AppColors.primary,
          dotColor: isDark
              ? Colors.black12
              : Colors.grey.shade400,
          dotHeight: 9,
          dotWidth: 18,
          spacing: 12,
        ),
      ),
    );
  }
}