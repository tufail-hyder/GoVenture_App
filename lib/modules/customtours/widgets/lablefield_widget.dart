import 'package:flutter/material.dart';
import '../screens/customize_tour_screen.dart';

class LabeledField extends StatelessWidget {
  const LabeledField({super.key, required this.palette, required this.label, required this.child, this.required = false});
  final Palette palette;
  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.textSecondary),
            children: [
              TextSpan(text: label),
              if (required) const TextSpan(text: ' *', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
