import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

enum PaymentMethod { jazzcash, easypaisa, card }

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key, required this.bookingId, required this.trip});

  final String bookingId;
  final TripModel trip;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentMethod? _selected;
  bool _isProcessing = false;

  Future<void> _payNow() async {
    if (_selected == null) return;

    setState(() => _isProcessing = true);

    // TODO: this is the one piece that genuinely needs a secure backend
    // (Firebase Cloud Functions) before it can go live — see the chat
    // explanation for the architecture. This screen intentionally does
    // NOT call any JazzCash/Easypaisa/card API directly, and never will:
    // that would mean shipping merchant secrets inside the Flutter app.
    //
    // What belongs here once the backend exists:
    //   final result = await PaymentService.initiatePayment(
    //     bookingId: widget.bookingId,
    //     method: _selected!,
    //   );
    //   // then navigate to a "processing/verifying" screen that listens
    //   // to BookingService.watchBooking(bookingId) until a Cloud
    //   // Function flips paymentStatus to paid/failed after verifying
    //   // with the gateway server-side.

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() => _isProcessing = false);
      Get.snackbar(
        'Payment not connected yet',
        'The booking is saved as pending — payment processing needs the backend described in chat.',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: textPrimary), onPressed: () => Get.back()),
        title: Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          Text('Select how you\'d like to pay', style: TextStyle(fontSize: 13.5, color: textSecondary)),
          const SizedBox(height: AppSizes.md),
          _MethodTile(
            method: PaymentMethod.jazzcash,
            selected: _selected,
            onTap: () => setState(() => _selected = PaymentMethod.jazzcash),
            icon: Icons.phone_android_rounded,
            title: 'JazzCash',
            subtitle: 'Mobile wallet',
            surface: surface,
            divider: divider,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: AppSizes.sm),
          _MethodTile(
            method: PaymentMethod.easypaisa,
            selected: _selected,
            onTap: () => setState(() => _selected = PaymentMethod.easypaisa),
            icon: Icons.account_balance_wallet_rounded,
            title: 'Easypaisa',
            subtitle: 'Mobile wallet',
            surface: surface,
            divider: divider,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: AppSizes.sm),
          _MethodTile(
            method: PaymentMethod.card,
            selected: _selected,
            onTap: () => setState(() => _selected = PaymentMethod.card),
            icon: Icons.credit_card_rounded,
            title: 'Debit / Credit Card',
            subtitle: 'Visa, Mastercard',
            surface: surface,
            divider: divider,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Icon(Icons.lock_rounded, size: 15, color: textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Payments are processed and verified server-side — your card/wallet details are never stored in this app.',
                  style: TextStyle(fontSize: 11.5, color: textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 4),
        decoration: BoxDecoration(
          color: surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              onPressed: (_selected == null || _isProcessing) ? null : _payNow,
              child: _isProcessing
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                  : Text('Pay PKR ${widget.trip.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.surface,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
  });

  final PaymentMethod method;
  final PaymentMethod? selected;
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color surface;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == method;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: isSelected ? AppColors.primary : divider, width: isSelected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: AppColors.primary),
            const SizedBox(width: AppSizes.sm + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: textPrimary)),
                  Text(subtitle, style: TextStyle(fontSize: 12.5, color: textSecondary)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}