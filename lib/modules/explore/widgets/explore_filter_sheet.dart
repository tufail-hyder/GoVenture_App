import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/explore_controller.dart';

class ExploreFilterSheet extends StatelessWidget {
  const ExploreFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreController>();

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    Obx(() => TextButton(
                      onPressed: controller.activeFilterCount > 0 ? controller.resetFilters : null,
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  children: [
                    const _SectionLabel('Location'),
                    const SizedBox(height: AppSizes.sm),
                    Obx(() => Wrap(
                      spacing: AppSizes.sm,
                      runSpacing: AppSizes.sm,
                      children: controller.availableLocations.map((loc) {
                        final selected = controller.selectedLocations.contains(loc);
                        return _FilterChip(
                          label: loc,
                          selected: selected,
                          onTap: () => controller.toggleLocation(loc),
                        );
                      }).toList(),
                    )),
                    const SizedBox(height: AppSizes.lg),

                    const _SectionLabel('Price Range'),
                    const SizedBox(height: AppSizes.sm),
                    Obx(() {
                      final range = controller.priceRange.value;
                      return Column(
                        children: [
                          RangeSlider(
                            values: range,
                            min: controller.minPriceBound,
                            max: controller.maxPriceBound,
                            divisions: 20,
                            activeColor: AppColors.primary,
                            labels: RangeLabels(
                              'PKR ${range.start.round()}',
                              'PKR ${range.end.round()}',
                            ),
                            onChanged: controller.setPriceRange,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('PKR ${range.start.round()}',
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                              Text('PKR ${range.end.round()}',
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: AppSizes.lg),

                    const _SectionLabel('Trip Type'),
                    const SizedBox(height: AppSizes.sm),
                    Obx(() => Wrap(
                      spacing: AppSizes.sm,
                      runSpacing: AppSizes.sm,
                      children: controller.availableTypes.map((type) {
                        final selected = controller.selectedTypes.contains(type);
                        return _FilterChip(
                          label: _capitalize(type),
                          selected: selected,
                          onTap: () => controller.toggleType(type),
                        );
                      }).toList(),
                    )),
                    const SizedBox(height: AppSizes.lg),

                    const _SectionLabel('Duration'),
                    const SizedBox(height: AppSizes.sm),
                    Wrap(
                      spacing: AppSizes.sm,
                      runSpacing: AppSizes.sm,
                      children: [
                        _DurationChip(controller: controller, value: '1-3', label: '1–3 Days'),
                        _DurationChip(controller: controller, value: '4-7', label: '4–7 Days'),
                        _DurationChip(controller: controller, value: '8+', label: '8+ Days'),
                      ],
                    ),
                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),

              // ---- Apply button ----
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Obx(() => SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Show ${controller.filteredTrips.length} Tours',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )),
              ),
            ],
          ),
        );
      },
    );
  }

  String _capitalize(String text) => text.isEmpty ? '' : text[0].toUpperCase() + text.substring(1);
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimaryLight),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryLight,
      backgroundColor: Colors.transparent,
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textPrimaryLight,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
        side: BorderSide(color: selected ? AppColors.primary : AppColors.dividerLight),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({required this.controller, required this.value, required this.label});

  final ExploreController controller;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedDuration.value == value;
      return _FilterChip(
        label: label,
        selected: selected,
        onTap: () => controller.setDurationBucket(value),
      );
    });
  }
}