import 'package:flutter/material.dart';
import '../../../models/banner_model.dart';
import '../../../core/constants/app_sizes.dart';

class AnnouncementBanner extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback onCtaTap;

  const AnnouncementBanner({super.key, required this.banner, required this.onCtaTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: Stack(
        children: [
          SizedBox(
            height: 160, width: double.infinity,
            child: banner.imageUrl.isNotEmpty
                ? Image.network(banner.imageUrl, fit: BoxFit.cover)
                : Container(color: Colors.grey.shade400),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black87, Colors.transparent],
              ),
            ),
          ),
          Positioned(
            left: AppSizes.md, right: AppSizes.md, top: AppSizes.md, bottom: AppSizes.md,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(banner.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(banner.description,
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: AppSizes.sm),
                ElevatedButton(
                  onPressed: onCtaTap,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(120, 36)),
                  child: Text(banner.ctaText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}