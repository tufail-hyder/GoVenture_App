import 'package:flutter/material.dart';
import '../../booking/models/booking_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

Future<void> showManageBookingSheet(
    BuildContext context, {
      required BookingModel booking,
      required Future<bool> Function() onConfirmCancel,
    }) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ManageBookingSheet(booking: booking, onConfirmCancel: onConfirmCancel),
  );
}

class _ManageBookingSheet extends StatefulWidget {
  final BookingModel booking;
  final Future<bool> Function() onConfirmCancel;
  const _ManageBookingSheet({required this.booking, required this.onConfirmCancel});

  @override
  State<_ManageBookingSheet> createState() => _ManageBookingSheetState();
}

class _ManageBookingSheetState extends State<_ManageBookingSheet> {
  bool _isCancelling = false;
  bool _confirmingCancel = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final alreadyCancelled = widget.booking.bookingStatus == 'cancelled';

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
          Text('Manage Booking', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 4),
          Text(widget.booking.tripTitle, style: TextStyle(fontSize: 13, color: textSecondary)),
          const SizedBox(height: AppSizes.md),

          if (alreadyCancelled) ...[
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.error, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('This booking has already been cancelled.', style: TextStyle(color: textSecondary, fontSize: 13))),
              ],
            ),
            const SizedBox(height: AppSizes.md),
          ] else if (!_confirmingCancel) ...[
            _SheetOption(
              icon: Icons.cancel_outlined,
              label: 'Cancel Booking',
              destructive: true,
              onTap: () => setState(() => _confirmingCancel = true),
            ),
          ] else ...[
            // ===== Confirmation step =====
            Container(
              padding: const EdgeInsets.all(AppSizes.sm + 4),
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
              child: Text(
                'Are you sure you want to cancel this booking? This action cannot be undone.',
                style: TextStyle(fontSize: 13, color: textPrimary, height: 1.4),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isCancelling ? null : () => setState(() => _confirmingCancel = false),
                    child: const Text('Keep Booking'),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    onPressed: _isCancelling
                        ? null
                        : () async {
                      setState(() => _isCancelling = true);
                      final success = await widget.onConfirmCancel();
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? 'Booking cancelled.' : 'Could not cancel booking. Please try again.')),
                        );
                      }
                    },
                    child: _isCancelling
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Yes, Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool destructive;
  final VoidCallback onTap;
  const _SheetOption({required this.icon, required this.label, this.destructive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimaryLight;
    final color = destructive ? AppColors.error : AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: AppSizes.sm),
            Text(label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: destructive ? color : textPrimary)),
          ],
        ),
      ),
    );
  }
}