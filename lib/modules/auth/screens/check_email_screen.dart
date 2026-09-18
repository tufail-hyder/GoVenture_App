import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/auth/screens/login_screen.dart';
import '../../../core/constants/app_text.dart';
import '../controllers/auth_controller.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class CheckEmailScreen extends StatelessWidget {
  final String email;

  const CheckEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final primary = isDark ? AppColors.primaryDarkMode : AppColors.primary;
    final primaryLight = isDark ? AppColors.surfaceDark : AppColors.primaryLight;
    final textPrimary =
    isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
    isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: surface,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: surface,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              // ---------- Top hero image with logo + envelope illustration ----------
              SizedBox(
                height: size.height * 0.5,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      AppImages.g1,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: kToolbarHeight + AppSizes.md,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Image.asset(
                            AppImages.appLightLogo,
                            width: size.width * 0.42,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: AppSizes.xs),
                          Text(
                            AppTexts.appTagline,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textSecondary,
                              fontSize: AppSizes.fontMd - 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ---------- Rounded confirmation card ----------
              Positioned(
                top: size.height * 0.41,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: surface,
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.lg,
                      AppSizes.xl,
                      AppSizes.lg,
                      AppSizes.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: primary,
                            size: AppSizes.iconLg,
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: AppSizes.fontXxl - 4,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                            children: [
                              const TextSpan(
                                  text: AppTexts.checkEmailTitlePrefix),
                              TextSpan(
                                text: AppTexts.checkEmailTitleHighlight,
                                style: TextStyle(color: primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          AppTexts.checkEmailSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),

                        // Info box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSizes.md),
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline,
                                  color: primary, size: AppSizes.iconSm + 4),
                              const SizedBox(width: AppSizes.sm),
                              Expanded(
                                child: Text(
                                  AppTexts.linkExpiryNote,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.4,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),

                        // Back to Sign In — styling comes from AppTheme.elevatedButtonTheme
                        SizedBox(
                          width: double.infinity,
                          height: AppSizes.buttonHeight - 4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              Get.offAll(() =>  LoginScreen());
                            },
                            child: Text(
                              AppTexts.backToSignIn,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),

                        // Resend — now actually re-sends the reset email
                        // instead of doing nothing.
                        Obx(() => RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textSecondary,
                            ),
                            children: [
                              const TextSpan(
                                  text: AppTexts.didntReceiveEmailPrompt),
                              TextSpan(
                                text: AppTexts.resendLink,
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = controller.isLoading.value
                                      ? null
                                      : () async {
                                    final success = await controller
                                        .sendPasswordResetEmail(email);
                                    if (success) {
                                      Get.snackbar(
                                        'Email sent',
                                        'Check your inbox for the reset link.',
                                        snackPosition: SnackPosition.TOP,
                                      );
                                    }
                                  },
                              ),
                            ],
                          ),
                        )),

                        Obx(() {
                          if (controller.errorText.value.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(top: AppSizes.md),
                              child: Text(
                                controller.errorText.value,
                                style: TextStyle(color: AppColors.error),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}