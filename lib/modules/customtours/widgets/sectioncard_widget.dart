import 'package:flutter/cupertino.dart';

import '../../../core/constants/app_sizes.dart';
import '../screens/customize_tour_screen.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.palette, required this.icon, required this.title, required this.children});

  final Palette palette;
  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [BoxShadow(color: palette.shadow, blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: palette.primarySoft, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 17, color: palette.primary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: palette.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm + 2),
          ...children,
        ],
      ),
    );
  }
}
