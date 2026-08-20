import 'package:flutter/material.dart';
import '../../../models/trip_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import 'section_title.dart';

class TripItinerarySection extends StatelessWidget {
  final List<ItineraryDay> itinerary;
  final String pdfUrl;
  final VoidCallback? onViewPdf;

  const TripItinerarySection({
    super.key,
    required this.itinerary,
    this.pdfUrl = '',
    this.onViewPdf,
  });

  @override
  Widget build(BuildContext context) {
    if (itinerary.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TripSectionTitle('Day-wise Itinerary'),
            if (pdfUrl.isNotEmpty)
              GestureDetector(
                onTap: onViewPdf,
                child: Row(
                  children: const [
                    Icon(Icons.picture_as_pdf_rounded, size: 16, color: AppColors.primary),
                    SizedBox(width: 3),
                    Text('View PDF', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSizes.sm + 2),
        ...List.generate(itinerary.length, (index) {
          final day = itinerary[index];
          final isLast = index == itinerary.length - 1;
          return _ItineraryTile(day: day, isLast: isLast);
        }),
      ],
    );
  }
}

class _ItineraryTile extends StatelessWidget {
  final ItineraryDay day;
  final bool isLast;

  const _ItineraryTile({required this.day, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Timeline: circle + connecting line =====
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.dividerLight),
                ),
            ],
          ),
          const SizedBox(width: AppSizes.sm),

          // ===== Content =====
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${day.day}: ${day.title}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimaryLight),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    day.description,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}