import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/auth/screens/signup_screen.dart';
import 'package:goventure/modules/root/root_screen.dart';
import '../../../core/constants/app_text.dart';
import '../controllers/auth_controller.dart';
import '../../../services/auth_service.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/auth_field.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool _obscurePassword = true.obs;

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
        statusBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness:
        isDark ? Brightness.dark : Brightness.light,
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
                height: size.height * 0.45,
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
                                fontSize: AppSizes.fontMd - 1,fontWeight: FontWeight.w600
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
                top: size.height * 0.42,
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
                              const TextSpan(text: AppTexts.loginWelcomePrefix),
                              TextSpan(
                                text: AppTexts.loginWelcomeHighlight,
                                style: TextStyle(color: primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          AppTexts.loginSubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: textSecondary,fontSize: 15
                          ),
                        ),
                        const SizedBox(height: AppSizes.md),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: AuthField(
                            controller: emailController,
                            hint: AppTexts.emailHint,
                            icon: Icons.mail_outline,
                            textColor: textPrimary,
                            hintColor: textSecondary,
                            borderColor: divider,
                            focusColor: primary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm+8),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: Obx(
                                () => AuthField(
                              controller: passwordController,
                              hint: AppTexts.passwordHint,
                              icon: Icons.lock_outline,
                              obscure: _obscurePassword.value,
                              textColor: textPrimary,
                              hintColor: textSecondary,
                              borderColor: divider,
                              focusColor: primary,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscurePassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: textSecondary,
                                  size: AppSizes.iconSm + 4,
                                ),
                                onPressed: () {
                                  _obscurePassword.value =
                                  !_obscurePassword.value;
                                },
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.offAll(() =>  ForgotPasswordScreen());
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 36),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              AppTexts.forgotPassword,
                              style: theme.textTheme.labelMedium?.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w600,fontSize: 14
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),

                        // Sign in button — styling comes from AppTheme.elevatedButtonTheme
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
                                : () {
                              Get.offAll(() => const RootScreen());
                            },
                            child: controller.isLoading.value
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            ) : Text(AppTexts.signIn,style: TextStyle(fontSize: 16),),
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
                                    ?.copyWith(color: textSecondary,fontSize: 14),
                              ),
                            ),
                            Expanded(child: Divider(color: divider)),
                          ],
                        ),
                        const SizedBox(height: AppSizes.md),

                        // Google sign in
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
                                : () => controller.signInWithGoogle(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.googleIcon,
                                  height: AppSizes.iconMd ,
                                  width: AppSizes.iconMd ,
                                ),
                                const SizedBox(width: AppSizes.sm + 8),
                                Text(
                                  AppTexts.signInWithGoogle,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
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
                                style:
                                theme.textTheme.titleMedium?.copyWith(
                                  fontSize: AppSizes.fontLg,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.signInWithApple(),
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
                                const TextSpan(text: AppTexts.noAccountPrompt),
                                TextSpan(
                                  text: AppTexts.signUp,
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.offAll(() =>  SignupScreen());
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

