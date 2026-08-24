import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/custom_tour_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/country_picker_sheet_widget.dart';

String _formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
}

/// Resolves the right colors for the current brightness (light/dark) so this
/// screen looks correct under either theme, without needing every color to
/// already exist as a "Dark" variant in AppColors.
class _Palette {
  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color primary;
  final Color primarySoft;
  final Color shadow;

  const _Palette({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.primary,
    required this.primarySoft,
    required this.shadow,
  });

  factory _Palette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return _Palette(
        background: const Color(0xFF0F1113),
        surface: const Color(0xFF1A1D21),
        surfaceRaised: const Color(0xFF20242A),
        textPrimary: Colors.white,
        textSecondary: const Color(0xFFA3A8B0),
        divider: const Color(0xFF2C3036),
        primary: AppColors.primary,
        primarySoft: AppColors.primary.withValues(alpha: 0.22),
        shadow: Colors.black.withValues(alpha: 0.45),
      );
    }
    return _Palette(
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      surfaceRaised: Colors.white,
      textPrimary: AppColors.textPrimaryLight,
      textSecondary: AppColors.textSecondaryLight,
      divider: AppColors.dividerLight,
      primary: AppColors.primary,
      primarySoft: AppColors.primaryLight,
      shadow: AppColors.cardShadow,
    );
  }
}

class CustomizeTourScreen extends StatelessWidget {
  const CustomizeTourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomTourController());
    final p = _Palette.of(context);

    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(
        backgroundColor: p.background,
        elevation: 0,
        title: Text(
          'Customize Your Tour',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: p.textPrimary),
        ),
        iconTheme: IconThemeData(color: p.textPrimary),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.xl),
          children: [
            // ---- Intro banner ----
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [p.primary, p.primary.withValues(alpha: 0.78)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                boxShadow: [BoxShadow(color: p.primary.withValues(alpha: 0.28), blurRadius: 18, offset: const Offset(0, 8))],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  const Expanded(
                    child: Text(
                      'You can plan your own tour according to your preferences for a group '
                          'of like-minded individuals, friends, family, or even as a solo '
                          'traveler. Just provide us with some basic details in the form and '
                          'let us do the rest!',
                      style: TextStyle(fontSize: 13, height: 1.5, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),

            _SectionCard(
              palette: p,
              icon: Icons.explore_rounded,
              title: 'Where do you want to go?',
              children: [
                _LabeledField(
                  palette: p,
                  label: 'Location',
                  child: _TextInput(
                    palette: p,
                    controller: controller.locationCtrl,
                    hint: 'e.g. Hunza, Skardu, Fairy Meadows',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Please tell us where you want to go' : null,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Tour URL (optional)',
                  child: _TextInput(
                    palette: p,
                    controller: controller.tourUrlCtrl,
                    hint: 'Link to a tour you liked, if any',
                    keyboardType: TextInputType.url,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            _SectionCard(
              palette: p,
              icon: Icons.checklist_rounded,
              title: 'What arrangements do you want us to make?',
              children: [
                Obx(() => Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: CustomTourController.arrangementOptions.map((option) {
                    final selected = controller.selectedArrangements.contains(option);
                    return _SelectChip(
                      palette: p,
                      label: option,
                      selected: selected,
                      onTap: () => controller.toggleArrangement(option),
                    );
                  }).toList(),
                )),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            _SectionCard(
              palette: p,
              icon: Icons.event_note_rounded,
              title: 'Trip Details',
              children: [
                _LabeledField(
                  palette: p,
                  label: 'Group Size',
                  child: _TextInput(
                    palette: p,
                    controller: controller.groupSizeCtrl,
                    hint: 'e.g. 6 people',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Group Details',
                  child: _TextInput(
                    palette: p,
                    controller: controller.groupDetailsCtrl,
                    hint: 'e.g. Friends group, mostly in their 20s',
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        palette: p,
                        label: 'No. of Days',
                        child: _TextInput(
                          palette: p,
                          controller: controller.daysCtrl,
                          hint: 'e.g. 5',
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            return int.tryParse(v.trim()) == null ? 'Enter a number' : null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: _LabeledField(
                        palette: p,
                        label: 'No. of Rooms',
                        child: _TextInput(palette: p, controller: controller.roomsCtrl, hint: 'e.g. 3', keyboardType: TextInputType.number),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        palette: p,
                        label: 'Start Date',
                        child: Obx(() => _DateInput(
                          palette: p,
                          value: controller.startDate.value,
                          hint: 'Select date',
                          error: controller.startDateError.value,
                          onTap: () => controller.pickStartDate(context),
                        )),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: _LabeledField(
                        palette: p,
                        label: 'End Date',
                        child: Obx(() => _DateInput(
                          palette: p,
                          value: controller.endDate.value,
                          hint: 'Select date',
                          error: controller.endDateError.value,
                          onTap: () => controller.pickEndDate(context),
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Start Location',
                  child: _TextInput(
                    palette: p,
                    controller: controller.startLocationCtrl,
                    hint: 'e.g. Islamabad',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'End Location',
                  child: _TextInput(
                    palette: p,
                    controller: controller.endLocationCtrl,
                    hint: 'e.g. Islamabad',
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            _SectionCard(
              palette: p,
              icon: Icons.tune_rounded,
              title: 'Do you have any preferences in terms of:',
              children: [
                _LabeledField(
                  palette: p,
                  label: 'Accommodation',
                  child: _TextInput(palette: p, controller: controller.accommodationPrefCtrl, hint: 'e.g. Hotel, guest house, camping'),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Transport',
                  child: _TextInput(palette: p, controller: controller.transportPrefCtrl, hint: 'e.g. Private jeep, coaster'),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Meals',
                  child: _TextInput(palette: p, controller: controller.mealsPrefCtrl, hint: 'e.g. Halal only, vegetarian options'),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Activities',
                  child: _TextInput(palette: p, controller: controller.activitiesPrefCtrl, hint: 'e.g. Hiking, photography, local culture'),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Guide',
                  child: _TextInput(palette: p, controller: controller.guidePrefCtrl, hint: 'e.g. English-speaking guide preferred'),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Special Requirements / Medical Conditions',
                  child: _TextInput(
                    palette: p,
                    controller: controller.specialRequirementsCtrl,
                    hint: 'Let us know if there\'s anything we should prepare for',
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            _SectionCard(
              palette: p,
              icon: Icons.payments_rounded,
              title: 'What\'s your budget?',
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _LabeledField(
                        palette: p,
                        label: 'Per Person',
                        child: _TextInput(
                          palette: p,
                          controller: controller.budgetCtrl,
                          hint: 'e.g. 25000',
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            return double.tryParse(v.trim()) == null ? 'Enter a valid amount' : null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      flex: 2,
                      child: _LabeledField(
                        palette: p,
                        label: 'Currency',
                        child: Obx(() => _DropdownInput<String>(
                          palette: p,
                          value: controller.selectedCurrency.value,
                          items: CustomTourController.currencies
                              .map((c) => DropdownMenuItem(value: c['code'], child: Text(c['label']!, overflow: TextOverflow.ellipsis)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) controller.selectedCurrency.value = v;
                          },
                        )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            _SectionCard(
              palette: p,
              icon: Icons.person_rounded,
              title: 'Contact Details',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        palette: p,
                        label: 'First Name',
                        child: _TextInput(
                          palette: p,
                          controller: controller.firstNameCtrl,
                          hint: 'First name',
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: _LabeledField(
                        palette: p,
                        label: 'Last Name',
                        child: _TextInput(
                          palette: p,
                          controller: controller.lastNameCtrl,
                          hint: 'Last name',
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Email Address',
                  child: _TextInput(
                    palette: p,
                    controller: controller.emailCtrl,
                    hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
                      return ok ? null : 'Enter a valid email';
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Phone',
                  child: _TextInput(
                    palette: p,
                    controller: controller.phoneCtrl,
                    hint: '+92 3xx xxxxxxx',
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                _LabeledField(
                  palette: p,
                  label: 'Nationality',
                  child: Obx(() => _PickerInput(
                    palette: p,
                    value: controller.nationality.value,
                    hint: 'Select Country',
                    error: controller.nationalityError.value,
                    onTap: () async {
                      final picked = await showCountryPicker(context, selected: controller.nationality.value);
                      if (picked != null) {
                        controller.nationality.value = picked;
                        controller.nationalityError.value = false;
                      }
                    },
                  )),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            _SectionCard(
              palette: p,
              icon: Icons.notes_rounded,
              title: 'Any other details?',
              children: [
                _TextInput(palette: p, controller: controller.otherDetailsCtrl, hint: 'Anything else we should know', maxLines: 4),
              ],
            ),
            const SizedBox(height: AppSizes.xl),

            // ---- Submit ----
            Obx(() => SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [p.primary, p.primary.withValues(alpha: 0.82)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: p.primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: controller.isSubmitting.value
                        ? null
                        : () async {
                      final success = await controller.submit();
                      if (success) {
                        Get.back();
                        Get.snackbar(
                          'Request Sent',
                          'Thanks! Our team will get back to you shortly with a custom itinerary.',
                          backgroundColor: p.primary,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(AppSizes.md),
                          borderRadius: AppSizes.radiusMd,
                        );
                      } else {
                        Get.snackbar(
                          'Something went wrong',
                          'Please check the highlighted fields and try again.',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.all(AppSizes.md),
                          borderRadius: AppSizes.radiusMd,
                        );
                      }
                    },
                    child: Center(
                      child: controller.isSubmitting.value
                          ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                      )
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Send Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.send_rounded, size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ==================== Shared small building blocks ====================

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.palette, required this.icon, required this.title, required this.children});

  final _Palette palette;
  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: palette.primarySoft, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 17, color: palette.primary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: palette.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm + 2),
          ...children,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.palette, required this.label, required this.child});
  final _Palette palette;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.textSecondary)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.palette,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  final _Palette palette;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(color: palette.divider),
    );
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      cursorColor: palette.primary,
      style: TextStyle(fontSize: 14, color: palette.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.5, color: palette.textSecondary),
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: palette.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}

class _DateInput extends StatelessWidget {
  const _DateInput({
    required this.palette,
    required this.value,
    required this.hint,
    required this.onTap,
    this.error = false,
  });
  final _Palette palette;
  final DateTime? value;
  final String hint;
  final VoidCallback onTap;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: error ? Colors.redAccent : palette.divider, width: error ? 1.3 : 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null ? _formatDate(value!) : hint,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: value != null ? palette.textPrimary : palette.textSecondary,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today_rounded, size: 15, color: palette.textSecondary),
              ],
            ),
          ),
        ),
        if (error)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text('Required', style: TextStyle(fontSize: 11.5, color: Colors.redAccent.shade200)),
          ),
      ],
    );
  }
}

class _PickerInput extends StatelessWidget {
  const _PickerInput({
    required this.palette,
    required this.value,
    required this.hint,
    required this.onTap,
    this.error = false,
  });
  final _Palette palette;
  final String? value;
  final String hint;
  final VoidCallback onTap;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: error ? Colors.redAccent : palette.divider, width: error ? 1.3 : 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: value != null ? palette.textPrimary : palette.textSecondary,
                    ),
                  ),
                ),
                Icon(Icons.expand_more_rounded, size: 18, color: palette.textSecondary),
              ],
            ),
          ),
        ),
        if (error)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text('Required', style: TextStyle(fontSize: 11.5, color: Colors.redAccent.shade200)),
          ),
      ],
    );
  }
}

class _DropdownInput<T> extends StatelessWidget {
  const _DropdownInput({required this.palette, required this.value, required this.items, required this.onChanged});
  final _Palette palette;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: palette.divider),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: palette.surfaceRaised,
          icon: Icon(Icons.expand_more_rounded, size: 18, color: palette.textSecondary),
          style: TextStyle(fontSize: 13.5, color: palette.textPrimary),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({required this.palette, required this.label, required this.selected, required this.onTap});
  final _Palette palette;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? palette.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
          border: Border.all(color: selected ? palette.primary : palette.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 15,
              color: selected ? palette.primary : palette.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: selected ? palette.primary : palette.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}