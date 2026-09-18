import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class TravelerCounter extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final int minValue;
  final ValueChanged<int> onChanged;

  const TravelerCounter({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: textPrimary)),
                Text(subtitle, style: TextStyle(fontSize: 12.5, color: textSecondary)),
              ],
            ),
          ),
          _RoundIconButton(icon: Icons.remove, onTap: value > minValue ? () => onChanged(value - 1) : null),
          SizedBox(width: 26, child: Center(child: Text('$value', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: textPrimary)))),
          _RoundIconButton(icon: Icons.add, onTap: () => onChanged(value + 1)),
        ],
      ),
    );
  }
}

/// Outlined (not filled) round +/- button, matching the mockup.
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: enabled ? AppColors.primary.withValues(alpha: 0.5) : AppColors.dividerLight.withValues(alpha: 0.6),
            width: 1.2,
          ),
        ),
        child: Icon(icon, size: 15, color: enabled ? AppColors.primary : AppColors.textSecondaryLight),
      ),
    );
  }
}