import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  // ⚠️ Replace with your real support contact details.
  static const String supportEmail = 'support@goventure.pk';
  static const String supportPhone = '+923001234567';
  static const String whatsappNumber = '923001234567';

  Future<void> _launch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    final items = [
      (
        icon: Icons.email_outlined,
        label: 'Email Us',
        subtitle: supportEmail,
        onTap: () => _launch(Uri(scheme: 'mailto', path: supportEmail)),
      ),
      (
        icon: Icons.call_outlined,
        label: 'Call Us',
        subtitle: supportPhone,
        onTap: () => _launch(Uri(scheme: 'tel', path: supportPhone)),
      ),
      (
        icon: Icons.chat_outlined,
        label: 'WhatsApp',
        subtitle: 'Chat with support',
        onTap: () => _launch(Uri.parse('https://wa.me/$whatsappNumber')),
      ),
    ];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('Help Center', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
        itemBuilder: (context, i) {
          final item = items[i];
          return Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: divider),
            ),
            child: InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm + 4),
                child: Row(
                  children: [
                    Icon(item.icon, color: AppColors.primary, size: 22),
                    const SizedBox(width: AppSizes.sm + 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: textPrimary)),
                          const SizedBox(height: 2),
                          Text(item.subtitle, style: TextStyle(fontSize: 12.5, color: textSecondary)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 18, color: textSecondary),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none_rounded, size: 48, color: textSecondary),
            const SizedBox(height: AppSizes.sm),
            Text('No notifications yet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary)),
          ],
        ),
      ),
    );
  }
}