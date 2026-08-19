import 'package:flutter/material.dart';
import '../../../models/trip_model.dart';
import '../../../core/constants/app_sizes.dart';

class DestinationCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback onTap;

  const DestinationCard({super.key, required this.trip, required this.onTap});

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
              height: 190,
              child: trip.coverImage.isNotEmpty
                  ? Image.network(trip.coverImage, fit: BoxFit.cover)
                  : Container(color: Colors.grey.shade300),
            ),
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
                          Row(children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.white),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(trip.title,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ]),
                          Text(trip.location,
                              style: const TextStyle(color: Colors.white70, fontSize: 12)),
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