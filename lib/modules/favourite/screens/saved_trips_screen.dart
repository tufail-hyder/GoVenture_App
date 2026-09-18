import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goventure/modules/tripdetails/screens/trip_detail_screen.dart';
import '../../mybookings/controllers/my_bookings_controller.dart';
import '../../mybookings/widgets/save_trip_card.dart';
import '../../home/models/destination_model.dart';
import '../../home/screens/destination_detail_screen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../controllers/favorites_controller.dart';
import '../services/favourite_services.dart';
import '../widgets/saved_destination_card.dart';

class SavedTripsScreen extends StatefulWidget {
  const SavedTripsScreen({super.key});

  @override
  State<SavedTripsScreen> createState() => _SavedTripsScreenState();
}

class _SavedTripsScreenState extends State<SavedTripsScreen> with SingleTickerProviderStateMixin {
  late final MyBookingsController controller;
  late final TabController _tabController;

  List<DestinationModel> _destinations = [];
  bool _isLoadingDestinations = true;
  bool _hasDestinationsError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    controller = Get.isRegistered<MyBookingsController>()
        ? Get.find<MyBookingsController>()
        : Get.put(MyBookingsController());
    controller.fetchSaved();
    _fetchDestinations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchDestinations() async {
    setState(() {
      _isLoadingDestinations = true;
      _hasDestinationsError = false;
    });
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _destinations = [];
        _isLoadingDestinations = false;
      });
      return;
    }
    try {
      final dests = await FavoritesService.getFavoriteDestinations(uid);
      setState(() {
        _destinations = dests;
        _isLoadingDestinations = false;
      });
    } catch (e) {
      setState(() {
        _hasDestinationsError = true;
        _isLoadingDestinations = false;
      });
    }
  }

  Future<void> _removeDestination(String destinationId) async {
    setState(() => _destinations.removeWhere((d) => d.id == destinationId));
    await Get.find<FavoritesController>().toggleDestination(destinationId);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: background,
      body: Obx(() {
        final tripsCount = controller.savedTrips.length;
        final destCount = _destinations.length;

        return NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              backgroundColor: background,
              elevation: 0,
              pinned: true,
              floating: true,
              title: Text('Saved', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(96),
                child: Column(
                  children: [
                    // ===== Stats row =====
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.sm),
                      child: Row(
                        children: [
                          Expanded(child: _StatChip(icon: Icons.card_travel_rounded, label: '$tripsCount Trips')),
                          const SizedBox(width: 10),
                          Expanded(child: _StatChip(icon: Icons.landscape_rounded, label: '$destCount Destinations')),
                        ],
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primary,
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Trips'),
                        Tab(text: 'Destinations'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              _AllTab(
                controller: controller,
                destinations: _destinations,
                isLoadingDestinations: _isLoadingDestinations,
                onRemoveDestination: _removeDestination,
              ),
              _TripsTab(controller: controller),
              _DestinationsTab(
                destinations: _destinations,
                isLoading: _isLoadingDestinations,
                hasError: _hasDestinationsError,
                onRetry: _fetchDestinations,
                onRemove: _removeDestination,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: scheme.onSurface)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 13, color: textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _TripsTab extends StatelessWidget {
  final MyBookingsController controller;
  const _TripsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingSaved.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.hasSavedError.value) {
        return _ErrorState(onRetry: controller.fetchSaved, message: 'Could not load your saved trips.');
      }
      final trips = controller.savedTrips;
      if (trips.isEmpty) {
        return const _EmptyState(
          icon: Icons.card_travel_rounded,
          title: 'No saved trips yet',
          subtitle: 'Tap the heart icon on any trip to save it here.',
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
              key: ValueKey(trip.id),
              trip: trip,
              onTap: () => Get.to(() => TripDetailScreen(tripId: trip.id)),
              onRemove: () => controller.toggleSaved(trip.id),
            );
          },
        ),
      );
    });
  }
}

class _DestinationsTab extends StatelessWidget {
  final List<DestinationModel> destinations;
  final bool isLoading;
  final bool hasError;
  final Future<void> Function() onRetry;
  final Future<void> Function(String) onRemove;

  const _DestinationsTab({
    required this.destinations,
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (hasError) return _ErrorState(onRetry: onRetry, message: 'Could not load saved destinations.');

    if (destinations.isEmpty) {
      return const _EmptyState(
        icon: Icons.landscape_rounded,
        title: 'No saved destinations yet',
        subtitle: 'Tap the heart icon on any destination to save it here.',
      );
    }

    return RefreshIndicator(
      onRefresh: onRetry,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.md),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final dest = destinations[index];
          return SavedDestinationCard(
            destination: dest,
            onTap: () => Get.to(() => DestinationDetailScreen(destinationId: dest.id)),
            onRemove: () => onRemove(dest.id),
          );
        },
      ),
    );
  }
}

class _AllTab extends StatelessWidget {
  final MyBookingsController controller;
  final List<DestinationModel> destinations;
  final bool isLoadingDestinations;
  final Future<void> Function(String) onRemoveDestination;

  const _AllTab({
    required this.controller,
    required this.destinations,
    required this.isLoadingDestinations,
    required this.onRemoveDestination,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tripsLoading = controller.isLoadingSaved.value;
      final trips = controller.savedTrips;

      if (tripsLoading || isLoadingDestinations) {
        return const Center(child: CircularProgressIndicator());
      }

      if (trips.isEmpty && destinations.isEmpty) {
        return const _EmptyState(
          icon: Icons.favorite_border_rounded,
          title: 'Nothing saved yet',
          subtitle: 'Tap the heart icon on any trip or destination to save it here.',
        );
      }

      return ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          if (trips.isNotEmpty) ...[
            _SectionLabel(title: 'Trips', count: trips.length),
            const SizedBox(height: AppSizes.sm),
            ...trips.map((trip) => SavedTripCard(
              trip: trip,
              onTap: () => Get.to(() => TripDetailScreen(tripId: trip.id)),
              onRemove: () => controller.toggleSaved(trip.id),
            )),
            const SizedBox(height: AppSizes.md),
          ],
          if (destinations.isNotEmpty) ...[
            _SectionLabel(title: 'Destinations', count: destinations.length),
            const SizedBox(height: AppSizes.sm),
            ...destinations.map((dest) => SavedDestinationCard(
              destination: dest,
              onTap: () => Get.to(() => DestinationDetailScreen(destinationId: dest.id)),
              onRemove: () => onRemoveDestination(dest.id),
            )),
          ],
        ],
      );
    });
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final int count;
  const _SectionLabel({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Text('$count', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Future<void> Function() onRetry;
  final String message;
  const _ErrorState({required this.onRetry, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 44, color: textSecondary),
            const SizedBox(height: AppSizes.sm),
            Text(message, style: TextStyle(color: textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.md),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}