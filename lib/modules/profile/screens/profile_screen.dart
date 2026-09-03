import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/mybookings/screens/my_bookings_screen.dart';
import '../../../services/trip_terms_services.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../widgets/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
    final displayName = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : 'Guest';
    final email = user?.email ?? '';
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
          // ===== Avatar + Name + Email =====
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: primaryLight,
                  backgroundImage: (user?.photoURL != null && user!.photoURL!.isNotEmpty)
                      ? NetworkImage(user.photoURL!)
                      : null,
                  child: (user?.photoURL == null || user!.photoURL!.isEmpty)
                      ? Text(initial, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: primary))
                      : null,
                ),
                const SizedBox(height: AppSizes.sm + 4),
                Text(displayName, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: textPrimary)),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(email, style: TextStyle(fontSize: 13.5, color: textSecondary)),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          // ===== Edit Profile shortcut =====
          _ProfileTile(
            icon: Icons.edit_outlined,
            label: 'Edit Profile',
            surface: surface,
            textPrimary: textPrimary,
            iconColor: primary,
            onTap: () {
              Get.offAll(() => EditProfileScreen());
            },
          ),
          const SizedBox(height: AppSizes.sm),

          // ===== Account section =====
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
                onTap: () {
                  Get.offAll(() => MyBookingsScreen());
                },
              ),
              _ProfileTile(
                icon: Icons.favorite_border_rounded,
                label: 'Saved Trips',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () {
                  // TODO: navigate to Saved tab.
                },
              ),
              _ProfileTile(
                icon: Icons.notifications_none_rounded,
                label: 'Notifications',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // ===== Preferences section =====
          _SectionLabel('Preferences', textSecondary: textSecondary),
          _ProfileCard(
            surface: surface,
            divider: divider,
            children: [
              _ProfileTile(
                icon: Icons.language_rounded,
                label: 'Language',
                trailingText: 'English',
                surface: surface,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                iconColor: primary,
                onTap: () {},
              ),
              _ProfileTile(
                icon: Icons.attach_money_rounded,
                label: 'Currency',
                trailingText: 'PKR',
                surface: surface,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                iconColor: primary,
                onTap: () {},
              ),
              _ProfileTile(
                icon: Icons.dark_mode_outlined,
                label: 'Dark Mode',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () {
                  // TODO: wire to your theme controller if you have one.
                },
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          // ===== Support section =====
          _SectionLabel('Support', textSecondary: textSecondary),
          _ProfileCard(
            surface: surface,
            divider: divider,
            children: [
              _ProfileTile(
                icon: Icons.help_outline_rounded,
                label: 'Help Center',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () {},
              ),
              _ProfileTile(
                icon: Icons.description_outlined,
                label: 'Terms & Conditions',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () {
                  Get.offAll(() => TermsService());
                },
              ),
              _ProfileTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                surface: surface,
                textPrimary: textPrimary,
                iconColor: primary,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),

          // ===== Logout =====
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
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
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
    this.trailingText,
    this.textSecondary,
  });

  final IconData icon;
  final String label;
  final Color surface;
  final Color textPrimary;
  final Color iconColor;
  final VoidCallback onTap;
  final String? trailingText;
  final Color? textSecondary;

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
            if (trailingText != null)
              Text(trailingText!, style: TextStyle(fontSize: 13, color: textSecondary)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 18, color: textSecondary ?? textPrimary.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}