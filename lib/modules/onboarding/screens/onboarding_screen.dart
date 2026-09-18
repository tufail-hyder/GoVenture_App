import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_text.dart';
import '../controllers/onboarding_contoller.dart';
import '../widgets/on_boarding_dot_navigation.dart';
import '../widgets/on_boarding_next_button.dart';
import '../widgets/on_boarding_page.dart';
import '../widgets/on_boarding_skip.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: AppImages.onBoardingImage1,
                titleLine1: AppTexts.onboardingTitle1Line1,
                titleLine2: AppTexts.onboardingTitle1Line2,
                subTitle: AppTexts.onboardingSubTitle1,
                icon: Icons.explore_outlined,
                showBrand: true,
              ),
              OnBoardingPage(
                image: AppImages.onBoardingImage2,
                titleLine1: AppTexts.onboardingTitle2Line1,
                titleLine2: AppTexts.onboardingTitle2Line2,
                subTitle: AppTexts.onboardingSubTitle2,
                icon: Icons.backpack_outlined,
              ),
              OnBoardingPage(
                image: AppImages.onBoardingImage3,
                titleLine1: AppTexts.onboardingTitle3Line1,
                titleLine2: AppTexts.onboardingTitle3Line2,
                subTitle: AppTexts.onboardingSubTitle3,
                icon: Icons.groups_outlined,
              ),
            ],
          ),

          const OnBoardingSkip(),
          const OnBoardingDotNavigation(),
          const OnBoardingNextButton(),
        ],
      ),
        ),
    );
  }
}