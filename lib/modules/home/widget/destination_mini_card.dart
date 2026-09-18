import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_sizes.dart';
import '../../favourite/controllers/favorites_controller.dart';
import '../models/destination_model.dart';

class DestinationMiniCard extends StatelessWidget {
  final DestinationModel destination;
  final VoidCallback onTap;

  const DestinationMiniCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = Get.find<FavoritesController>();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            destination.coverImage.isNotEmpty
                ? Image.network(
              destination.coverImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade400),
            )
                : Container(color: Colors.grey.shade400),

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

            Positioned(
              top: AppSizes.sm,
              right: AppSizes.sm,
              child: Obx(() {
                final isFav = favorites.isFavoriteDestination(destination.id);
                return GestureDetector(
                  onTap: () => favorites.toggleDestination(destination.id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 18,
                      color: isFav ? Colors.redAccent : Colors.white,
                    ),
                  ),
                );
              }),
            ),

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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    destination.location,
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