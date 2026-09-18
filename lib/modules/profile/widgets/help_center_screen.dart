import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../models/support_contact_model.dart';
import '../services/support_contact_service.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

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

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('Help Center', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: FutureBuilder<SupportContactModel>(
        future: SupportContactService.getSupportContact(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final contact = snapshot.data ?? SupportContactModel.empty();
          final items = [
            (
            icon: Icons.email_outlined,
            label: 'Email Us',
            subtitle: contact.email.isNotEmpty ? contact.email : 'Not available',
            onTap: contact.email.isEmpty ? null : () => _launch(Uri(scheme: 'mailto', path: contact.email)),
            ),
            (
            icon: Icons.call_outlined,
            label: 'Call Us',
            subtitle: contact.phone.isNotEmpty ? contact.phone : 'Not available',
            onTap: contact.phone.isEmpty ? null : () => _launch(Uri(scheme: 'tel', path: contact.phone)),
            ),
            (
            icon: Icons.chat_outlined,
            label: 'WhatsApp',
            subtitle: 'Chat with support',
            onTap: contact.whatsapp.isEmpty
                ? null
                : () => _launch(Uri.parse('https://wa.me/${contact.whatsapp.replaceAll('+', '')}')),
            ),
          ];

          return ListView.separated(
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
          );
        },
      ),
    );
  }
}
