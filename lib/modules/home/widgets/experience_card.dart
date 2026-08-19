import 'package:flutter/material.dart';
import '../../../models/trip_model.dart';
import '../../../core/constants/app_sizes.dart';

class ExperienceCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const ExperienceCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Stack(
          children: [
            SizedBox(
              width: 170,
              height: 170,
              child: trip.coverImage.isNotEmpty
                  ? Image.network(trip.coverImage, fit: BoxFit.cover)
                  : Container(color: Colors.grey.shade400),
            ),
            // Icon badge — top-left (admin ka diya hua tag icon ke bajaye
            // generic "explore" icon, kyunke icon mapping hardcode nahi karni)
            Positioned(
              top: AppSizes.sm,
              left: AppSizes.sm,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.black54,
                child: const Icon(Icons.explore_outlined, size: 16, color: Colors.white),
              ),
            ),
            // Title + tag — bottom-left, arrow — bottom-right
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSizes.sm + 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            trip.experienceTag.isNotEmpty ? trip.experienceTag : trip.title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(trip.type, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white24,
                      child: const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}