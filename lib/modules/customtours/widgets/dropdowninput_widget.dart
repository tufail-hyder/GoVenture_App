
import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../screens/customize_tour_screen.dart';

class DropdownInput<T> extends StatelessWidget {
  const DropdownInput({super.key, required this.palette, required this.value, required this.items, required this.onChanged});
  final Palette palette;
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