import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../controllers/onboarding_contoller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Positioned(
      left: AppSizes.lg,
      right: AppSizes.lg,
      bottom: 30,
      child: Obx(() {
        final isLastPage = controller.currentPageIndex.value == 2;

        return SizedBox(
          width: double.infinity,
          height: AppSizes.buttonHeight + 1,
          child: ElevatedButton(
            onPressed: controller.nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Text exact center mein
                Center(
                  child: Text(
                    isLastPage
                        ? AppTexts.getStarted
                        : AppTexts.next,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const Positioned(
                  right: 18,
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}