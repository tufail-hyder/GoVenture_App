import 'package:flutter/material.dart';
import 'package:goventure/core/constants/app_images.dart';
import '../../../models/trip_model.dart';
import '../../../core/constants/app_sizes.dart';

class DestinationMiniCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const DestinationMiniCard({super.key, required this.trip, required this.onTap});

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
            trip.coverImage.isNotEmpty
                ? Image.asset(AppImages.g6, fit: BoxFit.fill)
                : Container(color: Colors.grey.shade400),

            // ===== Bottom gradient =====
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.5, 1.0],
                ),
              ),
            ),

            // ===== Text + Arrow button (overlay) =====
            Positioned(
              left: AppSizes.sm,
              right: AppSizes.sm,
              bottom: AppSizes.sm,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.white),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                trip.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          trip.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.xs),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white24,
                    child: const Icon(Icons.arrow_forward, size: 15, color: Colors.white),
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