import 'package:flutter/material.dart';
import '../../../models/banner_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class SeasonalBannerStrip extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback onCtaTap;

  const SeasonalBannerStrip({super.key, required this.banner, required this.onCtaTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Stack(
        children: [
          SizedBox(
            height: 110, width: double.infinity,
            child: banner.imageUrl.isNotEmpty
                ? Image.network(banner.imageUrl, fit: BoxFit.cover)
                : Container(color: AppColors.primaryLight),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Positioned(
            left: AppSizes.md, top: 0, bottom: 0,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(banner.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(banner.description,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: AppSizes.sm, top: 0, bottom: 0,
            child: Center(
              child: TextButton(
                onPressed: onCtaTap,
                style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                child: Text(banner.ctaText, style: const TextStyle(fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}