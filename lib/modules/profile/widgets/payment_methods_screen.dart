import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final methods = [
      ('JazzCash', Icons.smartphone_rounded),
      ('EasyPaisa', Icons.smartphone_rounded),
      ('Credit / Debit Card', Icons.credit_card_rounded),
      ('Bank Transfer', Icons.account_balance_rounded),
    ];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('Payment Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          Text('Supported payment methods for bookings:', style: TextStyle(fontSize: 13, color: textSecondary)),
          const SizedBox(height: AppSizes.md),
          ...methods.map((m) => Container(
            margin: const EdgeInsets.only(bottom: AppSizes.sm),
            padding: const EdgeInsets.all(AppSizes.sm + 4),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
            child: Row(
              children: [
                Icon(m.$2, color: AppColors.primary),
                const SizedBox(width: AppSizes.sm),
                Text(m.$1, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textPrimary)),
              ],
            ),
          )),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Icon(Icons.lock_rounded, size: 15, color: textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'For your security, card and wallet details are never saved in this app — payment is chosen fresh at checkout.',
                  style: TextStyle(fontSize: 11.5, color: textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}