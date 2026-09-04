import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/tripdetails/screens/trip_detail_screen.dart';
import '../../mybookings/controllers/my_bookings_controller.dart';
import '../../mybookings/widgets/save_trip_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class SavedTripsScreen extends StatefulWidget {
  const SavedTripsScreen({super.key});

  @override
  State<SavedTripsScreen> createState() => _SavedTripsScreenState();
}

class _SavedTripsScreenState extends State<SavedTripsScreen> {
  late final MyBookingsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<MyBookingsController>()
        ? Get.find<MyBookingsController>()
        : Get.put(MyBookingsController());
    controller.fetchSaved();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: Text('Saved Trips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: Obx(() {
        if (controller.isLoadingSaved.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasSavedError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded, size: 44, color: textSecondary),
                  const SizedBox(height: AppSizes.sm),
                  Text('Could not load your saved trips.', style: TextStyle(color: textSecondary), textAlign: TextAlign.center),
                  const SizedBox(height: AppSizes.md),
                  ElevatedButton(onPressed: controller.fetchSaved, child: const Text('Retry')),
                ],
              ),
            ),
          );
        }

        final trips = controller.savedTrips;
        if (trips.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border_rounded, size: 48, color: textSecondary),
                  const SizedBox(height: AppSizes.sm),
                  Text('No saved trips yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
                  const SizedBox(height: 4),
                  Text(
                    'Tap the heart icon on any trip to save it here.',
                    style: TextStyle(fontSize: 13, color: textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchSaved,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return SavedTripCard(
                trip: trip,
                onTap: () => Get.to(() => TripDetailScreen(tripId: trip.id)),
                onRemove: () => controller.toggleSaved(trip.id),
              );
            },
          ),
        );
      }),
    );
  }
}