import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../models/destination_model.dart';

class DestinationMiniCard extends StatelessWidget {
  final DestinationModel destination;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;

  const DestinationMiniCard({
    super.key,
    required this.destination,
    required this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ===== Poori image background =====
            destination.coverImage.isNotEmpty
                ? Image.network(
              destination.coverImage,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: Colors.grey.shade400),
            )
                : Container(color: Colors.grey.shade400),

            // ===== Bottom gradient =====
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.4, 1.0],
                ),
              ),
            ),

            // ===== Favorite (heart) icon — top-right =====
            Positioned(
              top: AppSizes.sm,
              right: AppSizes.sm,
              child: GestureDetector(
                onTap: onFavoriteTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border_rounded, size: 18, color: Colors.white),
                ),
              ),
            ),

            // ===== Title + Location + Rating (bottom overlay) =====
            Positioned(
              left: AppSizes.sm,
              right: AppSizes.sm,
              bottom: AppSizes.sm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(destination.location,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}