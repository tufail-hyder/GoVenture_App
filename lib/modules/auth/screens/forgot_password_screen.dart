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
import '../widgets/auth_field.dart';
import 'check_email_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

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
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;

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
              // ---------- Top hero image with logo + title ----------
              SizedBox(
                height: size.height * 0.41,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      AppImages.g1,
                      fit: BoxFit.fill,
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

              // ---------- Rounded form card ----------
              Positioned(
                top: size.height * 0.38,
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
                        // Lock icon avatar with a small question-mark badge
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                color: primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock_outline,
                                color: primary,
                                size: AppSizes.iconLg,
                              ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: surface, width: 2),
                                ),
                                child: const Icon(
                                  Icons.question_mark_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
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
                                  text: AppTexts.forgotPasswordTitlePrefix),
                              TextSpan(
                                text: AppTexts.forgotPasswordTitleHighlight,
                                style: TextStyle(color: primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          AppTexts.forgotPasswordSubtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),

                        Obx(() => AuthField(
                          controller: emailController,
                          hint: AppTexts.emailHint,
                          icon: Icons.mail_outline,
                          textColor: textPrimary,
                          hintColor: textSecondary,
                          borderColor: divider,
                          focusColor: primary,
                          keyboardType: TextInputType.emailAddress,
                          errorText: controller.emailError.value,
                          onChanged: (_) => controller.clearEmailError(),
                        )),
                        const SizedBox(height: AppSizes.md),

                        // Send reset link — actually calls Firebase now,
                        // and only navigates when the email truly sends.
                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: AppSizes.buttonHeight - 4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                              final success = await controller.sendPasswordResetEmail(
                                emailController.text,
                              );
                              if (success) {
                                Get.to(() => CheckEmailScreen(
                                  email: emailController.text.trim(),
                                ));
                              }
                            },
                            child: controller.isLoading.value
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              AppTexts.sendResetLink,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )),
                        const SizedBox(height: AppSizes.md),

                        Row(
                          children: [
                            Expanded(child: Divider(color: divider)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.sm + 4),
                              child: Text(
                                AppTexts.orDivider,
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: textSecondary, fontSize: 14),
                              ),
                            ),
                            Expanded(child: Divider(color: divider)),
                          ],
                        ),
                        const SizedBox(height: AppSizes.md),

                        // Reset with Google — sign in flow via Google,
                        // then go straight to Login rather than the email
                        // reset step since there's no password to reset.
                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: AppSizes.buttonHeight - 4,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                              await controller.signInWithGoogle();
                              if (controller.errorText.value.isEmpty) {
                                Get.offAll(() => LoginScreen());
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.googleIcon,
                                  height: AppSizes.iconMd,
                                  width: AppSizes.iconMd,
                                ),
                                const SizedBox(width: AppSizes.sm + 8),
                                Text(
                                  AppTexts.resetWithGoogle,
                                  style:
                                  theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        const SizedBox(height: AppSizes.md),

                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textSecondary,
                            ),
                            children: [
                              const TextSpan(
                                  text: AppTexts.rememberPasswordPrompt),
                              TextSpan(
                                text: AppTexts.signIn,
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.offAll(() =>  LoginScreen());
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),

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