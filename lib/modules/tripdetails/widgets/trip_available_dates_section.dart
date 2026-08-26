import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'section_title.dart';

class TripAvailableDatesSection extends StatelessWidget {
  final List<DateTime> availableDates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const TripAvailableDatesSection({
    super.key,
    required this.availableDates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availableDates.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TripSectionTitle('Available Dates'),
        const SizedBox(height: AppSizes.sm + 2),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
            itemBuilder: (_, i) {
              final date = availableDates[i];
              final isSelected = selectedDate != null &&
                  date.year == selectedDate!.year &&
                  date.month == selectedDate!.month &&
                  date.day == selectedDate!.day;

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  width: 58,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(color: isSelected ? AppColors.primary : AppColors.dividerLight),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(DateFormat('d').format(date),
                          style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                      Text(DateFormat('MMM').format(date).toUpperCase(),
                          style: TextStyle(
                              color: isSelected ? Colors.white70 : AppColors.textSecondaryLight,
                              fontSize: 10)),
                      Text(DateFormat('yyyy').format(date),
                          style: TextStyle(
                              color: isSelected ? Colors.white70 : AppColors.textSecondaryLight,
                              fontSize: 9)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}