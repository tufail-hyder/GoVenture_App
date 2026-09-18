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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10), width: 1,),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.045,),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary,),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textPrimary, height: 1.1,),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }
}

class _Field extends StatefulWidget {
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
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: widget.textSecondary,fontFamily: "TimesNewRoman"),
            children: [
              TextSpan(text: widget.label),
              if (widget.required)
                const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800,fontFamily: "TimesNewRoman")),
            ],
          ),
        ),
        const SizedBox(height: 7),
        if (widget.errorListenable != null)
          Obx(() => _buildField(widget.errorListenable!.value))
        else
          _buildField(null),
      ],
    );
  }

  Widget _buildField(String? error) {
    final hasError = error != null;

    final Color borderColor = hasError ? Colors.redAccent.withValues(alpha: 0.75) : _isFocused ? AppColors.primary : AppColors.primary.withValues(alpha: 0.14);
    final double borderWidth = hasError ? 1.4 : _isFocused ? 1.5 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: hasError ? Colors.redAccent.withValues(alpha: 0.035) : AppColors.primary.withValues(alpha: 0.025),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              textInputAction: widget.maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: widget.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: widget.textSecondary.withValues(alpha: 0.75),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: widget.maxLines > 1 ? 13 : 14,
                ),
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline_rounded, size: 14, color: Colors.redAccent),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    error,
                    style: const TextStyle(fontSize: 11.5, color: Colors.redAccent, fontWeight: FontWeight.w600, height: 1.2),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}