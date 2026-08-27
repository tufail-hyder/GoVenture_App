import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'section_title.dart';

class TripDescriptionSection extends StatefulWidget {
  final String description;
  const TripDescriptionSection({super.key, required this.description});

  @override
  State<TripDescriptionSection> createState() => _TripDescriptionSectionState();
}

class _TripDescriptionSectionState extends State<TripDescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description.trim().isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TripSectionTitle('About This Trip'),
        const SizedBox(height: AppSizes.xs),
        Text(
          widget.description,
          maxLines: _expanded ? null : 4,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: textSecondary, height: 1.3),
        ),
        if (widget.description.length > 180)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _expanded ? 'Show Less' : 'Read More',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }
}