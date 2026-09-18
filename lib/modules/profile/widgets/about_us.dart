import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../models/about_us_model.dart';
import '../services/about_us_services.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Future<void> _launch(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final primary = isDark ? AppColors.primaryDarkMode : AppColors.primary;

    final heading = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary);
    final body = TextStyle(fontSize: 14, height: 1.6, color: textPrimary.withOpacity(0.9));
    final bulletStyle = TextStyle(fontSize: 13.5, height: 1.5, color: textPrimary.withOpacity(0.9));

    Widget sectionCard({required String title, required List<Widget> children}) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: heading),
            const SizedBox(height: AppSizes.sm + 2),
            ...children,
          ],
        ),
      );
    }

    Widget paragraphs(List<String> items) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSizes.sm),
            Text(items[i], style: body),
          ],
        ],
      );
    }

    Widget bulletLine(String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_rounded, size: 16, color: primary),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: bulletStyle)),
          ],
        ),
      );
    }

    Widget linkText(String label, String url) {
      if (url.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: InkWell(
          onTap: () => _launch(url),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: primary, decoration: TextDecoration.underline),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_outward_rounded, size: 14, color: primary),
            ],
          ),
        ),
      );
    }

    Widget milestone(String value, String label) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 4),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primary)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: textSecondary)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('About Us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: FutureBuilder<AboutUsModel>(
        future: AboutUsService.getAboutUs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final about = snapshot.data ?? AboutUsModel.empty();
          if (about.isEmpty) {
            return Center(
              child: Text('Content not available yet.', style: TextStyle(color: textSecondary)),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              if (about.whoWeAre.isNotEmpty)
                sectionCard(title: 'Who We Are', children: [Text(about.whoWeAre, style: body)]),

              if (about.milestoneYears.isNotEmpty ||
                  about.milestoneTravelers.isNotEmpty ||
                  about.milestoneTours.isNotEmpty ||
                  about.milestoneDestinations.isNotEmpty)
                sectionCard(title: 'Milestones', children: [
                  Row(children: [
                    milestone(about.milestoneYears, 'Years'),
                    milestone(about.milestoneTravelers, 'Travelers'),
                  ]),
                  Row(children: [
                    milestone(about.milestoneTours, 'Tours'),
                    milestone(about.milestoneDestinations, 'Destinations'),
                  ]),
                ]),

              if (about.whoWeServe.isNotEmpty)
                sectionCard(title: 'Who We Serve', children: [
                  Text(about.whoWeServe, style: body),
                  linkText('View Our Business Portfolio', about.businessPortfolioUrl),
                ]),

              if (about.whatMakesUsDifferent.isNotEmpty || about.differentiators.isNotEmpty)
                sectionCard(title: 'What Makes Us Different', children: [
                  if (about.whatMakesUsDifferent.isNotEmpty) ...[
                    Text(about.whatMakesUsDifferent, style: body),
                    const SizedBox(height: AppSizes.sm + 2),
                  ],
                  for (final point in about.differentiators) bulletLine(point),
                ]),

              if (about.whyUs.isNotEmpty)
                sectionCard(title: 'Why Us?', children: [paragraphs(about.whyUs)]),

              if (about.responsibleTourism.isNotEmpty || about.responsibleTourismPoints.isNotEmpty)
                sectionCard(title: 'Responsible Tourism Philosophy', children: [
                  if (about.responsibleTourism.isNotEmpty) paragraphs(about.responsibleTourism),
                  linkText('Visit Root Network', about.rootNetworkUrl),
                  if (about.responsibleTourismPoints.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.sm + 2),
                    for (final point in about.responsibleTourismPoints) bulletLine(point),
                  ],
                ]),

              if (about.founderBio.isNotEmpty)
                sectionCard(title: 'About the Founder', children: [
                  paragraphs(about.founderBio),
                  linkText(
                    about.founderName.isNotEmpty ? "${about.founderName}'s Instagram" : 'Founder\'s Instagram',
                    about.founderInstagramUrl,
                  ),
                ]),
            ],
          );
        },
      ),
    );
  }
}