import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:goventure/modules/profile/screens/settings_screen.dart';
import '../../mybookings/screens/my_bookings_screen.dart';
import '../../notification/screens/notification_screen.dart';
import '../services/trip_terms_services.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../favourite/screens/saved_trips_screen.dart';
import '../widgets/about_us.dart';
import '../widgets/edit_profile_screen.dart';
import '../widgets/feedback_screen.dart';
import '../widgets/help_center_screen.dart';
import '../widgets/my_reviews_screen.dart';
import '../widgets/payment_methods_screen.dart';
import '../widgets/terms_screen.dart';

// TODO: replace with your real store listing IDs once published.
const String _androidPackageId = 'com.goventure.app';
const String _iosAppStoreId = '0000000000';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareApp() {
    Share.share(
      'Check out GoVenture.pk – plan and book your next adventure across Pakistan!\n'
          'Android: https://play.google.com/store/apps/details?id=$_androidPackageId\n'
          'iOS: https://apps.apple.com/app/id$_iosAppStoreId',
    );
  }

  void _rateApp() {
    final uri = Theme.of(Get.context!).platform == TargetPlatform.iOS
        ? Uri.parse('https://apps.apple.com/app/id$_iosAppStoreId?action=write-review')
        : Uri.parse('https://play.google.com/store/apps/details?id=$_androidPackageId');
    _launch(uri);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final primary = isDark ? AppColors.primaryDarkMode : AppColors.primary;
    final primaryLight = isDark ? AppColors.surfaceDark : AppColors.primaryLight;

    final user = controller.currentUser;
    final displayName = (user?.displayName?.trim().isNotEmpty ?? false) ? user!.displayName!.trim() : 'Guest';
    final email = user?.email ?? '';
    final phone = user?.phoneNumber ?? '';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          // ===== Name/Email card — initial badge + name/email, boxed look =====
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: divider),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: primaryLight,
                  child: Text(
                    initial,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primary),
                  ),
                ),
                const SizedBox(width: AppSizes.sm + 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: textPrimary),
                      ),
                      if (email.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: textSecondary),
                        ),
                      ],
                      if (phone.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),

          _ProfileCard(
          surface: surface,
          divider: divider,
          children: [
            _ProfileTile(
              icon: Icons.edit_outlined,
              label: 'Edit Profile',
              surface: surface,
              textPrimary: textPrimary,
              iconColor: primary,
              onTap: () => Get.to(() => const EditProfileScreen()),
            ),
            ]
          ),
          const SizedBox(height: AppSizes.sm),

          _SectionLabel('Account', textSecondary: textSecondary),
          _ProfileCard(
            surface: surface,
            divider: divider,
            children: [
              _ProfileTile(
                icon: Icons.calendar_month_outlined,
                label: 'My Bookings',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const MyBookingsScreen()),
              ),
              _ProfileTile(
                icon: Icons.favorite_border_rounded,
                label: 'My Wishlist',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const SavedTripsScreen()),
              ),
              _ProfileTile(
                icon: Icons.rate_review_outlined,
                label: 'My Reviews',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const MyReviewsScreen()),
              ),
              _ProfileTile(
                icon: Icons.notifications_none_rounded,
                label: 'Notifications',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const NotificationsScreen()),
              ),
              _ProfileTile(
                icon: Icons.credit_card_rounded,
                label: 'Payment Method',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const PaymentMethodsScreen()),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          _SectionLabel('Preferences', textSecondary: textSecondary),
          _ProfileCard(
            surface: surface,
            divider: divider,
            children: [
              _ProfileTile(
                icon: Icons.settings_outlined,
                label: 'Settings',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const SettingsScreen()),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          _SectionLabel('Support', textSecondary: textSecondary),
          _ProfileCard(
            surface: surface,
            divider: divider,
            children: [
              _ProfileTile(
                icon: Icons.info_outline_rounded,
                label: 'About Us',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const AboutUsScreen()),
              ),
              _ProfileTile(
                icon: Icons.help_outline_rounded,
                label: 'Help & Support',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const HelpCenterScreen()),
              ),
              _ProfileTile(
                icon: Icons.feedback_outlined,
                label: 'Feedback',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => const FeedbackScreen()),
              ),
              _ProfileTile(
                icon: Icons.share_outlined,
                label: 'Share App',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: _shareApp,
              ),
              _ProfileTile(
                icon: Icons.star_outline_rounded,
                label: 'Rate Us',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: _rateApp,
              ),
              _ProfileTile(
                icon: Icons.description_outlined,
                label: 'Terms & Conditions',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => TermsScreen(
                  title: 'Terms & Conditions',
                  fetcher: TermsService.getTripTerms,
                )),
              ),
              _ProfileTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () => Get.to(() => TermsScreen(
                  title: 'Privacy Policy',
                  fetcher: TermsService.getPrivacyPolicy,
                )),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),

          _ProfileCard(
            surface: surface,
            divider: divider,
            children: [
              _ProfileTile(
                icon: Icons.logout_rounded,
                label: 'Log Out',
                surface: surface,
                textPrimary: AppColors.error,
                iconColor: AppColors.error,
                onTap: () => _confirmLogout(context, controller),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthController controller) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await controller.signOut();
              Get.offAll(() => LoginScreen());
            },
            child: const Text('Log Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.textSecondary});
  final String text;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.xs, AppSizes.sm, AppSizes.xs, AppSizes.xs),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: textSecondary),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.surface, required this.divider, required this.children});
  final Color surface;
  final Color divider;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: divider),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (i) {
          if (i.isOdd) return Divider(height: 1, color: divider, indent: 52);
          return children[i ~/ 2];
        }),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.surface,
    required this.textPrimary,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color surface;
  final Color textPrimary;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + 4, vertical: AppSizes.sm + 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: AppSizes.sm + 4),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: textPrimary)),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: textPrimary.withOpacity(0.35)),
          ],
        ),
      ),
    );
  }
}