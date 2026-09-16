import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../tripdetails/screens/trip_detail_screen.dart';
import '../../../services/trip_service.dart';
import '../widget/featured_trip_card.dart';
import '../widget/upcoming_trip_list_tile.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';

enum TripListMode { featured, all, upcoming }
enum _SortOption { none, priceLow, priceHigh, ratingHigh, azAsc, newest, durationShort, durationLong }

class TripsListScreen extends StatefulWidget {
  final TripListMode mode;

  const TripsListScreen({super.key, required this.mode});

  @override
  State<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  String _searchQuery = '';
  _SortOption _sortOption = _SortOption.none;
  final TextEditingController _searchController = TextEditingController();

  late final Future<List<TripModel>>? _tripsFuture;
  late final Future<List<TripModel>>? _upcomingTripsFuture;

  @override
  void initState() {
    super.initState();
    switch (widget.mode) {
      case TripListMode.featured:
        _tripsFuture = TripService.getFeaturedTrips(limit: 100);
        _upcomingTripsFuture = null;
        break;
      case TripListMode.all:
        _tripsFuture = TripService.getAllTrips(limit: 100);
        _upcomingTripsFuture = null;
        break;
      case TripListMode.upcoming:
        _tripsFuture = null;
        _upcomingTripsFuture = TripService.getUpcomingTrips(limit: 100);
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.mode) {
      case TripListMode.featured:
        return 'Featured Trips';
      case TripListMode.all:
        return 'All Tours';
      case TripListMode.upcoming:
        return 'Upcoming Tours';
    }
  }

  List<TripModel> _applySort(List<TripModel> list) {
    final sorted = [...list];
    switch (_sortOption) {
      case _SortOption.none:
        sorted.sort((a, b) {
          final aDate = TripService.nextAvailableDate(a);
          final bDate = TripService.nextAvailableDate(b);
          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return aDate.compareTo(bDate);
        });
        break;
      case _SortOption.priceLow:
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _SortOption.priceHigh:
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _SortOption.ratingHigh:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case _SortOption.azAsc:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case _SortOption.newest:
        sorted.sort((a, b) {
          final aDate = a.createdAt;
          final bDate = b.createdAt;
          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return bDate.compareTo(aDate);
        });
        break;
      case _SortOption.durationShort:
        sorted.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case _SortOption.durationLong:
        sorted.sort((a, b) => b.duration.compareTo(a.duration));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isGridMode = widget.mode != TripListMode.upcoming;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: isGridMode ? _buildTripGrid(scheme) : _buildUpcomingList(),
      ),
    );
  }

  // ===== Featured / All Tours: grid view (existing behavior) =====
  Widget _buildTripGrid(ColorScheme scheme) {
    return FutureBuilder<List<TripModel>>(
      future: _tripsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = snapshot.data ?? [];
        final query = _searchQuery.trim().toLowerCase();
        var trips = all.where((t) =>
        query.isEmpty ||
            t.title.toLowerCase().contains(query) ||
            t.location.toLowerCase().contains(query)).toList();
        trips = _applySort(trips);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: scheme.outline.withValues(alpha: 0.15)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search trips...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: PopupMenuButton<_SortOption>(
                      icon: Icon(Icons.sort_rounded, color: _sortOption == _SortOption.none ? null : AppColors.primary),
                      onSelected: (opt) => setState(() => _sortOption = opt),
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: _SortOption.priceLow, child: Text('Price: Low to High')),
                        PopupMenuItem(value: _SortOption.priceHigh, child: Text('Price: High to Low')),
                        PopupMenuItem(value: _SortOption.ratingHigh, child: Text('Rating: High to Low')),
                        PopupMenuItem(value: _SortOption.azAsc, child: Text('Sort A-Z')),
                      ],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  ),
                ),
              ),
            ),
            Expanded(
              child: trips.isEmpty
                  ? const Center(child: Text('No trips found'))
                  : GridView.builder(
                padding: const EdgeInsets.all(AppSizes.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.sm,
                  crossAxisSpacing: AppSizes.sm,
                  childAspectRatio: 0.72,
                ),
                itemCount: trips.length,
                itemBuilder: (_, i) => FeaturedTripCard(
                  trip: trips[i],
                  badgeText: 'Featured',
                  badgeColor: AppColors.primary,
                  onTap: () => Get.to(() => TripDetailScreen(tripId: trips[i].id)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===== Upcoming Tours: vertical list =====
  Widget _buildUpcomingList() {
    return FutureBuilder<List<TripModel>>(
      future: _upcomingTripsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final trips = snapshot.data ?? [];

        if (trips.isEmpty) {
          return const Center(child: Text('No upcoming tours'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.md),
          itemCount: trips.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
          itemBuilder: (_, i) => UpcomingTripListTile(
            trip: trips[i],
            onTap: () => Get.to(() => TripDetailScreen(tripId: trips[i].id)),
          ),
        );
      },
    );
  }
}