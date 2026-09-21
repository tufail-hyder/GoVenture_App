import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          Container(
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
            child: Column(
              children: [
                Obx(() => SwitchListTile(
                  title: Text('Dark Mode', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                  value: controller.isDarkMode,
                  activeColor: AppColors.primary,
                  onChanged: controller.toggleDarkMode,
                )),
                const Divider(height: 1),
                Obx(() => ListTile(
                  title: Text('Language', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                  trailing: Text(controller.language.value, style: TextStyle(color: textSecondary)),
                  onTap: () => _showPicker(context, 'Language', ['English'], controller.setLanguage),
                )),
                const Divider(height: 1),
                Obx(() => ListTile(
                  title: Text('Currency', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
                  trailing: Text(controller.currency.value, style: TextStyle(color: textSecondary)),
                  onTap: () => _showPicker(context, 'Currency', ['PKR',], controller.setCurrency),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context, String title, List<String> options, ValueChanged<String> onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map((o) => ListTile(
            title: Text(o),
            onTap: () {
              onSelect(o);
              Navigator.of(context).pop();
            },
          ))
              .toList(),
        ),
      ),
    );
  }
}