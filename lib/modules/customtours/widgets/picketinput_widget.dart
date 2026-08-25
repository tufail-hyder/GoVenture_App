import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../screens/customize_tour_screen.dart';

class PickerInput extends StatelessWidget {
  const PickerInput({
    required this.palette,
    required this.value,
    required this.hint,
    required this.onTap,
    this.error = false,
  });
  final Palette palette;
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
              border: Border.all(color: error ? Colors.redAccent : palette.divider, width: error ? 1.4 : 1),
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
            child: Text('Required', style: TextStyle(fontSize: 11.5, color: Colors.redAccent.shade200, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}