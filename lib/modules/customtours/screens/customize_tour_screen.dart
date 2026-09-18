import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/custom_tour_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../widgets/country_picker_sheet_widget.dart';
import '../widgets/dateinput_widget.dart';
import '../widgets/dropdowninput_widget.dart';
import '../widgets/lablefield_widget.dart';
import '../widgets/picketinput_widget.dart';
import '../widgets/sectioncard_widget.dart';
import '../widgets/select_chip_widget.dart';
import '../widgets/textinput_widget.dart';


class Palette {
  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color primary;
  final Color primarySoft;
  final Color shadow;

  const Palette({
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

  factory Palette.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return Palette(
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
    return Palette(
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
    final p = Palette.of(context);

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
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.xl),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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

            SectionCard(
              palette: p,
              icon: Icons.explore_rounded,
              title: 'Where do you want to go?',
              children: [
                LabeledField(
                  palette: p,
                  label: 'Location',
                  required: true,
                  child: Obx(() => TextInput(
                    palette: p,
                    controller: controller.locationCtrl,
                    hint: 'e.g. Hunza, Skardu, Fairy Meadows',
                    errorMessage: controller.locationError.value,
                  )),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Tour URL (optional)',
                  child: TextInput(
                    palette: p,
                    controller: controller.tourUrlCtrl,
                    hint: 'Link to a tour you liked, if any',
                    keyboardType: TextInputType.url,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            SectionCard(
              palette: p,
              icon: Icons.checklist_rounded,
              title: 'What arrangements do you want us to make?',
              children: [
                Obx(() => Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: CustomTourController.arrangementOptions.map((option) {
                    final selected = controller.selectedArrangements.contains(option);
                    return SelectChip(
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

            SectionCard(
              palette: p,
              icon: Icons.event_note_rounded,
              title: 'Trip Details',
              children: [
                LabeledField(
                  palette: p,
                  label: 'Group Size',
                  required: true,
                  child: Obx(() => TextInput(
                    palette: p,
                    controller: controller.groupSizeCtrl,
                    hint: 'e.g. 6 people',
                    errorMessage: controller.groupSizeError.value,
                  )),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Group Details',
                  child: TextInput(
                    palette: p,
                    controller: controller.groupDetailsCtrl,
                    hint: 'e.g. Friends group, mostly in their 20s',
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LabeledField(
                        palette: p,
                        label: 'No. of Days',
                        required: true,
                        child: Obx(() => TextInput(
                          palette: p,
                          controller: controller.daysCtrl,
                          hint: 'e.g. 5',
                          keyboardType: TextInputType.number,
                          errorMessage: controller.daysError.value,
                        )),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: LabeledField(
                        palette: p,
                        label: 'No. of Rooms',
                        required: true,
                        child: Obx(() => TextInput(
                          palette: p,
                          controller: controller.roomsCtrl,
                          hint: 'e.g. 3',
                          keyboardType: TextInputType.number,
                          errorMessage: controller.roomsError.value,
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LabeledField(
                        palette: p,
                        label: 'Start Date',
                        required: true,
                        child: Obx(() => DateInput(
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
                      child: LabeledField(
                        palette: p,
                        label: 'End Date',
                        required: true,
                        child: Obx(() => DateInput(
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
                LabeledField(
                  palette: p,
                  label: 'Start Location',
                  required: true,
                  child: Obx(() => TextInput(
                    palette: p,
                    controller: controller.startLocationCtrl,
                    hint: 'e.g. Islamabad',
                    errorMessage: controller.startLocationError.value,
                  )),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'End Location',
                  required: true,
                  child: Obx(() => TextInput(
                    palette: p,
                    controller: controller.endLocationCtrl,
                    hint: 'e.g. Islamabad',
                    errorMessage: controller.endLocationError.value,
                  )),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            SectionCard(
              palette: p,
              icon: Icons.tune_rounded,
              title: 'Do you have any preferences in terms of:',
              children: [
                LabeledField(
                  palette: p,
                  label: 'Accommodation',
                  child: TextInput(palette: p, controller: controller.accommodationPrefCtrl, hint: 'e.g. Hotel, guest house, camping'),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Transport',
                  child: TextInput(palette: p, controller: controller.transportPrefCtrl, hint: 'e.g. Private jeep, coaster'),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Meals',
                  child: TextInput(palette: p, controller: controller.mealsPrefCtrl, hint: 'e.g. Halal only, vegetarian options'),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Activities',
                  child: TextInput(palette: p, controller: controller.activitiesPrefCtrl, hint: 'e.g. Hiking, photography, local culture'),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Guide',
                  child: TextInput(palette: p, controller: controller.guidePrefCtrl, hint: 'e.g. English-speaking guide preferred'),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Special Requirements / Medical Conditions',
                  child: TextInput(
                    palette: p,
                    controller: controller.specialRequirementsCtrl,
                    hint: 'Let us know if there\'s anything we should prepare for',
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            SectionCard(
              palette: p,
              icon: Icons.payments_rounded,
              title: 'What\'s your budget?',
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: LabeledField(
                        palette: p,
                        label: 'Per Person',
                        required: true,
                        child: Obx(() => TextInput(
                          palette: p,
                          controller: controller.budgetCtrl,
                          hint: 'e.g. 25000',
                          keyboardType: TextInputType.number,
                          errorMessage: controller.budgetError.value,
                        )),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      flex: 2,
                      child: LabeledField(
                        palette: p,
                        label: 'Currency',
                        required: true,
                        child: Obx(() => DropdownInput<String>(
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

            SectionCard(
              palette: p,
              icon: Icons.person_rounded,
              title: 'Contact Details',
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: LabeledField(
                        palette: p,
                        label: 'First Name',
                        required: true,
                        child: Obx(() => TextInput(
                          palette: p,
                          controller: controller.firstNameCtrl,
                          hint: 'First name',
                          errorMessage: controller.firstNameError.value,
                        )),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: LabeledField(
                        palette: p,
                        label: 'Last Name',
                        required: true,
                        child: Obx(() => TextInput(
                          palette: p,
                          controller: controller.lastNameCtrl,
                          hint: 'Last name',
                          errorMessage: controller.lastNameError.value,
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Email Address',
                  required: true,
                  child: Obx(() => TextInput(
                    palette: p,
                    controller: controller.emailCtrl,
                    hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                    errorMessage: controller.emailError.value,
                  )),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Phone',
                  required: true,
                  child: Obx(() => TextInput(
                    palette: p,
                    controller: controller.phoneCtrl,
                    hint: '+92 3xx xxxxxxx',
                    keyboardType: TextInputType.phone,
                    errorMessage: controller.phoneError.value,
                  )),
                ),
                const SizedBox(height: AppSizes.sm),
                LabeledField(
                  palette: p,
                  label: 'Nationality',
                  required: true,
                  child: Obx(() => PickerInput(
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

            SectionCard(
              palette: p,
              icon: Icons.notes_rounded,
              title: 'Any other details?',
              children: [
                TextInput(palette: p, controller: controller.otherDetailsCtrl, hint: 'Anything else we should know', maxLines: 4),
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






