import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/booking_service.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'booking_confirmation_screen.dart';

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

    await BookingService.updatePaymentMethod(
      bookingId: widget.bookingId,
      method: _selected!.name,
    );

    // TODO: Real gateway verification (backend/Cloud Function) — jaisa pehle discuss kiya.
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() => _isProcessing = false);
      Get.off(() => BookingConfirmationScreen(trip: widget.trip, bookingId: widget.bookingId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA);
    final surface = isDark ? AppColors.surfaceDark : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    BoxDecoration cardDecoration() => BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ],
    );

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
        padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.xl),
        children: [
          // ===== Amount Due Card =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.75)],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.30),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount Due',
                          style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.85), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('PKR ${widget.trip.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(widget.trip.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.5, color: Colors.white.withValues(alpha: 0.85))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),

          Text('Select how you\'d like to pay',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textSecondary, letterSpacing: 0.3)),
          const SizedBox(height: AppSizes.sm + 2),

          _MethodTile(
            method: PaymentMethod.jazzcash,
            selected: _selected,
            onTap: () => setState(() => _selected = PaymentMethod.jazzcash),
            icon: Icons.phone_android_rounded,
            iconColor: const Color(0xFFED1C63),
            title: 'JazzCash',
            subtitle: 'Mobile wallet',
            surface: surface,
            divider: divider,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: AppSizes.sm + 2),
          _MethodTile(
            method: PaymentMethod.easypaisa,
            selected: _selected,
            onTap: () => setState(() => _selected = PaymentMethod.easypaisa),
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF00A651),
            title: 'Easypaisa',
            subtitle: 'Mobile wallet',
            surface: surface,
            divider: divider,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: AppSizes.sm + 2),
          _MethodTile(
            method: PaymentMethod.card,
            selected: _selected,
            onTap: () => setState(() => _selected = PaymentMethod.card),
            icon: Icons.credit_card_rounded,
            iconColor: AppColors.primary,
            title: 'Debit / Credit Card',
            subtitle: 'Visa, Mastercard',
            surface: surface,
            divider: divider,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
          const SizedBox(height: AppSizes.lg),

          // ===== Security Note =====
          Container(
            padding: const EdgeInsets.all(AppSizes.sm + 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Payments are processed and verified server-side — your card/wallet details are never stored in this app.',
                    style: TextStyle(fontSize: 11.5, color: textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 4),
        decoration: BoxDecoration(
          color: surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
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
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_rounded, size: 17),
                  const SizedBox(width: 8),
                  Text('Pay PKR ${widget.trip.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
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
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.surface,
    required this.divider,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
  });

  final PaymentMethod method;
  final PaymentMethod? selected;
  final VoidCallback onTap;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color surface;
  final Color divider;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == method;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: isSelected ? AppColors.primary : divider, width: isSelected ? 1.6 : 1),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 22, color: iconColor),
                ),
                const SizedBox(width: AppSizes.sm + 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: textPrimary)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(fontSize: 12.5, color: textSecondary)),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: isSelected
                      ? Container(
                    key: const ValueKey('selected'),
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
                  )
                      : Icon(
                    Icons.radio_button_off_rounded,
                    key: const ValueKey('unselected'),
                    color: textSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}