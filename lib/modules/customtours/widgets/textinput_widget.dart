import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../screens/customize_tour_screen.dart';

class TextInput extends StatelessWidget {
  const TextInput({super.key,
    required this.palette,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.errorMessage,
  });

  final Palette palette;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null;
    final normalBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(color: palette.divider),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      borderSide: BorderSide(color: palette.primary, width: 1.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          cursorColor: palette.primary,
          style: TextStyle(fontSize: 14, color: palette.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 13.5, color: palette.textSecondary),
            filled: true,
            fillColor: palette.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: hasError ? errorBorder : normalBorder,
            enabledBorder: hasError ? errorBorder : normalBorder,
            focusedBorder: hasError ? errorBorder : focusedBorder,
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(errorMessage!, style: TextStyle(fontSize: 11.5, color: Colors.redAccent.shade200, fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
