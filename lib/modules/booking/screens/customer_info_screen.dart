import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/booking/screens/payment_screen.dart';
import '../controllers/booking_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class CustomerInfoScreen extends StatelessWidget {
  const CustomerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    Future<void> handleContinue() async {
      final bookingId = await controller.submitCustomerInfo();
      if (bookingId == null) {
        if (controller.fullNameError.value == null &&
            controller.emailError.value == null &&
            controller.phoneError.value == null) {
          Get.snackbar(
            'Could not continue',
            'Please make sure you are signed in and try again.',
            snackPosition: SnackPosition.TOP,
          );
        }
        return;
      }
      Get.to(() => PaymentMethodScreen(bookingId: bookingId, trip: controller.trip));
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: textPrimary), onPressed: () => Get.back()),
        title: Text('Customer Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.xl),
        children: [
          _SectionCard(
            surface: surface,
            title: 'Traveler Details',
            icon: Icons.person_rounded,
            textPrimary: textPrimary,
            children: [
              _Field(
                label: 'Full Name',
                required: true,
                controller: controller.fullNameCtrl,
                errorListenable: controller.fullNameError,
                hint: 'As per CNIC/Passport',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                divider: divider,
              ),
              const SizedBox(height: AppSizes.sm + 2),
              _Field(
                label: 'Email',
                required: true,
                controller: controller.emailCtrl,
                errorListenable: controller.emailError,
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                divider: divider,
              ),
              const SizedBox(height: AppSizes.sm + 2),
              _Field(
                label: 'Phone Number',
                required: true,
                controller: controller.phoneCtrl,
                errorListenable: controller.phoneError,
                hint: '+92 3xx xxxxxxx',
                keyboardType: TextInputType.phone,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                divider: divider,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          _SectionCard(
            surface: surface,
            title: 'Special Requests',
            icon: Icons.notes_rounded,
            textPrimary: textPrimary,
            children: [
              _Field(
                label: 'Anything we should know? (optional)',
                controller: controller.specialRequestsCtrl,
                hint: 'Dietary needs, mobility concerns, etc.',
                maxLines: 3,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                divider: divider,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          _SectionCard(
            surface: surface,
            title: 'Emergency Contact',
            icon: Icons.emergency_share_rounded,
            textPrimary: textPrimary,
            children: [
              _Field(
                label: 'Contact Name (optional)',
                controller: controller.emergencyNameCtrl,
                hint: 'Name of a contact back home',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                divider: divider,
              ),
              const SizedBox(height: AppSizes.sm + 2),
              _Field(
                label: 'Contact Phone (optional)',
                controller: controller.emergencyPhoneCtrl,
                hint: '+92 3xx xxxxxxx',
                keyboardType: TextInputType.phone,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                divider: divider,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Obx(() => Container(
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
              onPressed: controller.isCreatingBooking.value ? null : handleContinue,
              child: controller.isCreatingBooking.value
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Continue to Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 19),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.surface,
    required this.title,
    required this.icon,
    required this.textPrimary,
    required this.children,
  });

  final Color surface;
  final String title;
  final IconData icon;
  final Color textPrimary;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: AppSizes.sm),
              Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: textPrimary)),
            ],
          ),
          const SizedBox(height: AppSizes.sm + 2),
          ...children,
        ],
      ),
    );
  }
}

/// Plain TextField driven by an explicit error message (not a
/// TextFormField + validator) — same reliable pattern used for the custom
/// tour request form, since Form.validate()'s error display doesn't
/// reliably sync with externally-set errorText.
class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    this.required = false,
    this.errorListenable,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final bool required;
  final TextEditingController controller;
  final Rxn<String>? errorListenable;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: textSecondary),
            children: [
              TextSpan(text: label),
              if (required) const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        if (errorListenable != null)
          Obx(() => _buildField(errorListenable!.value))
        else
          _buildField(null),
      ],
    );
  }

  Widget _buildField(String? error) {
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: hasError ? Colors.redAccent : divider, width: hasError ? 1.4 : 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(fontSize: 14, color: textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 13.5, color: textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(error, style: const TextStyle(fontSize: 11.5, color: Colors.redAccent, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}