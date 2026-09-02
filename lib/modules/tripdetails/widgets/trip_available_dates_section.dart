import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../models/trip_date_slot.dart';
import 'section_title.dart';

class TripAvailableDatesSection extends StatelessWidget {
  final List<TripDateSlot> availableDates;
  final TripDateSlot? selectedSlot;
  final ValueChanged<TripDateSlot> onSlotSelected;
  final int duration;

  const TripAvailableDatesSection({
    super.key,
    required this.availableDates,
    required this.selectedSlot,
    required this.onSlotSelected,
    required this.duration,
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
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
            itemBuilder: (_, i) {
              final slot = availableDates[i];
              final endDate = slot.date.add(Duration(days: duration > 0 ? duration - 1 : 0));
              final isSelected = selectedSlot != null &&
                  slot.date.year == selectedSlot!.date.year &&
                  slot.date.month == selectedSlot!.date.month &&
                  slot.date.day == selectedSlot!.date.day;
              final remaining = slot.remainingSeats;
              final isFull = remaining != null && remaining <= 0;
              final isLow = remaining != null && remaining > 0 && remaining <= 5;

              return GestureDetector(
                onTap: isFull ? null : () => onSlotSelected(slot),
                child: Opacity(
                  opacity: isFull ? 0.45 : 1,
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.sm, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.dividerLight),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${DateFormat('d MMM').format(slot.date)} - ${DateFormat('d MMM').format(endDate)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        Text(DateFormat('yyyy').format(slot.date),
                            style: TextStyle(color: isSelected ? Colors.white70 : AppColors.textSecondaryLight, fontSize: 13,fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        if (remaining != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white24
                                  : (isFull || isLow ? AppColors.error.withValues(alpha: 0.1) : AppColors.primaryLight),
                              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                            ),
                            child: Text(
                              isFull ? 'Fully Booked' : '$remaining seats left',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : (isFull || isLow ? AppColors.error : AppColors.primary),
                              ),
                            ),
                          ),
                      ],
                    ),
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