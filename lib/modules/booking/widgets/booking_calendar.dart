import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../tripdetails/models/trip_date_slot.dart';

class BookingCalendar extends StatelessWidget {
  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final List<TripDateSlot> availableDates;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const BookingCalendar({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.availableDates,
    required this.onDateSelected,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  bool _isAvailable(DateTime day) {
    return availableDates.any((s) =>
    s.date.year == day.year && s.date.month == day.month && s.date.day == day.day);
  }

  bool _isSelected(DateTime day) {
    return selectedDate != null &&
        selectedDate!.year == day.year && selectedDate!.month == day.month && selectedDate!.day == day.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    final firstDayOfMonth = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 0).day;
    final startWeekday = (firstDayOfMonth.weekday + 6) % 7;
    final prevMonthLastDay = DateTime(visibleMonth.year, visibleMonth.month, 0).day;
    final totalCells = ((startWeekday + daysInMonth) / 7).ceil() * 7;
    final totalWeeks = totalCells ~/ 7;

    DateTime cellDate(int index) {
      if (index < startWeekday) {
        return DateTime(visibleMonth.year, visibleMonth.month - 1, prevMonthLastDay - (startWeekday - index - 1));
      } else if (index >= startWeekday + daysInMonth) {
        return DateTime(visibleMonth.year, visibleMonth.month + 1, index - startWeekday - daysInMonth + 1);
      }
      return DateTime(visibleMonth.year, visibleMonth.month, index - startWeekday + 1);
    }

    bool inCurrentMonth(int index) => index >= startWeekday && index < startWeekday + daysInMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrevMonth),
            Expanded(
              child: Center(
                child: Text(
                  DateFormat('MMMM yyyy').format(visibleMonth),
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: textPrimary),
                ),
              ),
            ),
            _NavButton(icon: Icons.chevron_right_rounded, onTap: onNextMonth),
          ],
        ),
        const SizedBox(height: AppSizes.sm),

        Row(
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map((d) => Expanded(
            child: Center(
              child: Text(d, style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w600)),
            ),
          ))
              .toList(),
        ),
        const SizedBox(height: 4),

        for (int week = 0; week < totalWeeks; week++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: List.generate(7, (col) {
                final index = week * 7 + col;
                final day = cellDate(index);
                final current = inCurrentMonth(index);
                final available = current && _isAvailable(day);
                final selected = current && _isSelected(day);
                final tappable = available;

                Color textColor;
                FontWeight weight;
                if (selected) {
                  textColor = Colors.white;
                  weight = FontWeight.w700;
                } else if (!current) {
                  textColor = textSecondary.withValues(alpha: 0.3);
                  weight = FontWeight.w400;
                } else if (available) {
                  textColor = textPrimary;
                  weight = FontWeight.w600;
                } else {
                  textColor = textSecondary.withValues(alpha: 0.45);
                  weight = FontWeight.w400;
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: tappable ? () => onDateSelected(day) : null,
                    child: Center(
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(fontSize: 13, fontWeight: weight, color: textColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textPrimary = Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimaryLight;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(icon, size: 20, color: textPrimary),
      ),
    );
  }
}