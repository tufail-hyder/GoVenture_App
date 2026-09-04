import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../booking/models/booking_model.dart';

// ---- Update these to your real support contact details. ----
const String _supportEmail = 'goventure001@gmail.com';
const String _supportPhone = '+923400189816';

Future<void> showContactSupportSheet(BuildContext context, {required BookingModel booking}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ContactSupportSheet(booking: booking),
  );
}

class _ContactSupportSheet extends StatelessWidget {
  const _ContactSupportSheet({required this.booking});
  final BookingModel booking;

  String get _bookingCode {
    final raw = booking.id.length >= 6 ? booking.id.substring(0, 6) : booking.id;
    return 'GV${raw.toUpperCase()}';
  }

  Future<void> _openEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=${Uri.encodeComponent('Support for booking $_bookingCode')}'
          '&body=${Uri.encodeComponent('Hi GoVenture team,\n\nI need help with my booking $_bookingCode (${booking.tripTitle}).\n\n')}',
    );
    await launchUrl(uri);
  }

  Future<void> _openCall() async {
    await launchUrl(Uri(scheme: 'tel', path: _supportPhone));
  }

  Future<void> _openWhatsApp() async {
    final message = Uri.encodeComponent('Hi, I need help with my booking $_bookingCode (${booking.tripTitle}).');
    final uri = Uri.parse('https://wa.me/${_supportPhone.replaceAll('+', '')}?text=$message');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.lg),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4, margin: const EdgeInsets.only(bottom: AppSizes.md),
              decoration: BoxDecoration(color: textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(4)),
            ),
          ),
          Text('Contact Support', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 4),
          Text('Regarding booking $_bookingCode · ${booking.tripTitle}',
              style: TextStyle(fontSize: 13, color: textSecondary)),
          const SizedBox(height: AppSizes.md),

          _SupportOption(icon: Icons.chat_rounded, iconColor: const Color(0xFF25D366), label: 'WhatsApp', subtitle: _supportPhone, onTap: _openWhatsApp),
          _SupportOption(icon: Icons.call_rounded, iconColor: AppColors.primary, label: 'Call Us', subtitle: _supportPhone, onTap: _openCall),
          _SupportOption(icon: Icons.email_rounded, iconColor: AppColors.primary, label: 'Email Us', subtitle: _supportEmail, onTap: _openEmail),
        ],
      ),
    );
  }
}

class _SupportOption extends StatelessWidget {
  const _SupportOption({required this.icon, required this.iconColor, required this.label, required this.subtitle, required this.onTap});
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textSecondaryLight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: AppSizes.sm + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: textPrimary)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: textSecondary),
          ],
        ),
      ),
    );
  }
}