import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/destination_model.dart';
import '../services/destination_service.dart';
import 'destination_detail_screen.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';

class AllDestinationsScreen extends StatelessWidget {
  const AllDestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Destinations')),
      body: FutureBuilder<List<DestinationModel>>(
        future: DestinationService.getAllDestinations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final destinations = snapshot.data ?? [];
          if (destinations.isEmpty) {
            return const Center(child: Text('No destinations found'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(AppSizes.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSizes.sm,
              crossAxisSpacing: AppSizes.sm,
              childAspectRatio: 0.78,
            ),
            itemCount: destinations.length,
            itemBuilder: (_, i) {
              final dest = destinations[i];
              return GestureDetector(
                onTap: () => Get.to(() => DestinationDetailScreen(destinationId: dest.id)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      dest.coverImage.isNotEmpty
                          ? Image.network(
                        dest.coverImage,
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
                        left: AppSizes.sm,
                        right: AppSizes.sm,
                        bottom: AppSizes.sm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dest.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            if (dest.location.isNotEmpty)
                              Text(
                                dest.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}