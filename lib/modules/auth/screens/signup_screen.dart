import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/auth/screens/login_screen.dart';
import 'package:goventure/modules/root/root_screen.dart';
import '../../../core/constants/app_text.dart';
import '../../home/screens/home_screen.dart';
import '../controllers/auth_controller.dart';
import '../../../services/auth_service.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/auth_field.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final primary = isDark ? AppColors.primaryDarkMode : AppColors.primary;
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
                height: size.height * 0.4,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      AppImages.authHeroBg,
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
                top: size.height * 0.37,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: AppSizes.fontXxl - 4,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                            children: [
                              const TextSpan(text: AppTexts.createAccountPrefix),
                              TextSpan(
                                text: AppTexts.createAccountHighlight,
                                style: TextStyle(color: primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          AppTexts.signupSubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: textSecondary,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),

                        // First name / Last name
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => AuthField(
                                controller: firstNameController,
                                hint: AppTexts.firstNameHint,
                                icon: Icons.person_outline,
                                textColor: textPrimary,
                                hintColor: textSecondary,
                                borderColor: divider,
                                focusColor: primary,
                                errorText: controller.firstNameError.value,
                                onChanged: (_) => controller.clearFirstNameError(),
                              )),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: Obx(() => AuthField(
                                controller: lastNameController,
                                hint: AppTexts.lastNameHint,
                                icon: Icons.person_outline,
                                textColor: textPrimary,
                                hintColor: textSecondary,
                                borderColor: divider,
                                focusColor: primary,
                                errorText: controller.lastNameError.value,
                                onChanged: (_) => controller.clearLastNameError(),
                              )),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm + 8),

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
                        const SizedBox(height: AppSizes.sm + 8),

                        Obx(
                              () => AuthField(
                            controller: passwordController,
                            hint: AppTexts.passwordHint,
                            icon: Icons.lock_outline,
                            obscure: _obscurePassword.value,
                            textColor: textPrimary,
                            hintColor: textSecondary,
                            borderColor: divider,
                            focusColor: primary,
                            errorText: controller.passwordError.value,
                            onChanged: (_) => controller.clearPasswordError(),
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: textSecondary,
                                size: AppSizes.iconSm + 4,
                              ),
                              onPressed: () => _obscurePassword.value = !_obscurePassword.value,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm + 8),

                        Obx(
                              () => AuthField(
                            controller: confirmPasswordController,
                            hint: AppTexts.confirmPasswordHint,
                            icon: Icons.lock_outline,
                            obscure: _obscureConfirmPassword.value,
                            textColor: textPrimary,
                            hintColor: textSecondary,
                            borderColor: divider,
                            focusColor: primary,
                            errorText: controller.confirmPasswordError.value,
                            onChanged: (_) => controller.clearConfirmPasswordError(),
                            suffix: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: textSecondary,
                                size: AppSizes.iconSm + 4,
                              ),
                              onPressed: () => _obscureConfirmPassword.value = !_obscureConfirmPassword.value,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm + 4),

                        // Terms & privacy
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textSecondary,
                              fontSize: 12.5,
                            ),
                            children: [
                              const TextSpan(text: AppTexts.termsPrefix),
                              TextSpan(
                                text: AppTexts.termsOfService,
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              const TextSpan(text: AppTexts.termsConjunction),
                              TextSpan(
                                text: AppTexts.privacyPolicy,
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),

                        // Sign up button — actually calls Firebase now,
                        // and only navigates when it truly succeeds.
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
                              final success = await controller.signUpWithEmail(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                confirmPassword: confirmPasswordController.text,
                              );
                              if (success) {
                                Get.offAll(() => const RootScreen());
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
                              AppTexts.signUp,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )),

                        if (AuthService.shouldShowAppleSignIn) ...[
                          const SizedBox(height: AppSizes.sm + 4),
                          Obx(() => SizedBox(
                            width: double.infinity,
                            height: AppSizes.buttonHeight - 4,
                            child: OutlinedButton.icon(
                              icon: Icon(Icons.apple, color: textPrimary),
                              label: Text(
                                AppTexts.continueWithApple,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: AppSizes.fontLg,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () async {
                                await controller.signInWithApple();
                                if (controller.errorText.value.isEmpty) {
                                  Get.offAll(() => const RootScreen());
                                }
                              },
                            ),
                          )),
                        ],

                        const SizedBox(height: AppSizes.md),

                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: textSecondary,
                              ),
                              children: [
                                const TextSpan(
                                    text: AppTexts.alreadyHaveAccountPrompt),
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