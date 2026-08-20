import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'section_title.dart';

class TripHighlightsSection extends StatelessWidget {
  final List<String> highlights;
  const TripHighlightsSection({super.key, required this.highlights});

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TripSectionTitle('Trip Highlights'),
        const SizedBox(height: AppSizes.sm),
        ...highlights.map((h) => Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 20,
                height: 20,
                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 13, color: AppColors.primary),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  h,
                  style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimaryLight, height: 1.4),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}