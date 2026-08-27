import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../services/pdf_service.dart';
import 'section_title.dart';

class TripItinerarySection extends StatefulWidget {
  final List<ItineraryDay> itinerary;
  final String pdfUrl;
  final String tripTitle;
  final VoidCallback? onViewPdf;

  const TripItinerarySection({
    super.key,
    required this.itinerary,
    this.pdfUrl = '',
    this.tripTitle = 'Trip',
    this.onViewPdf,
  });

  @override
  State<TripItinerarySection> createState() => _TripItinerarySectionState();
}

class _TripItinerarySectionState extends State<TripItinerarySection> {
  bool _isDownloading = false;

  Future<void> _handleDownload() async {
    if (widget.pdfUrl.isEmpty) return;

    setState(() => _isDownloading = true);
    try {
      final fileName = '${widget.tripTitle.replaceAll(' ', '_')}_itinerary.pdf';
      final path = await PdfService.downloadToDevice(widget.pdfUrl, fileName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to: $path')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download failed. Please check your connection.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itinerary.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TripSectionTitle('Day-wise Itinerary'),
            if (widget.pdfUrl.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: widget.onViewPdf,
                    child: const Row(
                      children: [
                        Icon(Icons.picture_as_pdf_rounded, size: 16, color: AppColors.primary),
                        SizedBox(width: 3),
                        Text('View', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  GestureDetector(
                    onTap: _isDownloading ? null : _handleDownload,
                    child: _isDownloading
                        ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    )
                        : const Row(
                      children: [
                        Icon(Icons.download_rounded, size: 16, color: AppColors.primary),
                        SizedBox(width: 3),
                        Text('Download', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: AppSizes.sm + 2),
        ...widget.itinerary.map((day) => _ItineraryCard(day: day)),
      ],
    );
  }
}

class _ItineraryCard extends StatefulWidget {
  final ItineraryDay day;
  const _ItineraryCard({required this.day});

  @override
  State<_ItineraryCard> createState() => _ItineraryCardState();
}

class _ItineraryCardState extends State<_ItineraryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: divider),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.sm + 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: Center(
                      child: Text('${day.day}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Day ${day.day} — ${day.title}',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, height: 1.1, color: textPrimary),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        if (day.timeInfo.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              day.timeInfo,
                              style: TextStyle(fontSize: 13, height: 1.0, color: textSecondary),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: textSecondary),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.sm + 2, 0, AppSizes.sm + 2, AppSizes.sm + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 1, color: divider),
                  const SizedBox(height: AppSizes.sm),
                  Text(day.description, style: TextStyle(fontSize: 14, color: textSecondary, height: 1.4)),
                  if (day.location.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1.5),
                          child: Icon(Icons.location_on_rounded, size: 16, color: AppColors.primary),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            day.location,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (day.activities.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.sm),
                    ...day.activities.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(a, style: TextStyle(fontSize: 13, color: textPrimary, height: 1.3)),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}