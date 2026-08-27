import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../services/trip_terms_services.dart';
import '../models/trip_terms_model.dart';
import 'section_title.dart';

class TripTermsSection extends StatefulWidget {
  const TripTermsSection({super.key});

  @override
  State<TripTermsSection> createState() => _TripTermsSectionState();
}

class _TripTermsSectionState extends State<TripTermsSection> {
  late final Future<TermsModel> _future;

  @override
  void initState() {
    super.initState();
    _future = TermsService.getTripTerms();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TermsModel>(
      future: _future,
      builder: (context, snapshot) {
        // Still loading, failed, or genuinely empty — show nothing rather
        // than an error/spinner cluttering the trip page.
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        final content = snapshot.data?.content.trim() ?? '';
        if (content.isEmpty) return const SizedBox.shrink();

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
        final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;
        final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TripSectionTitle('Terms & Conditions'),
            const SizedBox(height: AppSizes.sm + 2),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.sm + 2),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: divider),
              ),
              child: Text(
                content,
                style: TextStyle(fontSize: 14, color: textSecondary, height: 1.6),
              ),
            ),
          ],
        );
      },
    );
  }
}