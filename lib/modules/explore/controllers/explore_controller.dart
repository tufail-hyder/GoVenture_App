import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../favourite/controllers/favorites_controller.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../services/trip_service.dart';

enum SortOption { priceLowHigh, priceHighLow, duration, popularity, newest, rating }

class ExploreController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxList<TripModel> _allTrips = <TripModel>[].obs;
  final RxList<TripModel> filteredTrips = <TripModel>[].obs;

  final FavoritesController _favorites = Get.find<FavoritesController>();

  // ===== Ab shared FavoritesController se hi favorite state milta hai =====
  RxSet<String> get favoriteTripIds => _favorites.tripIds;
  Future<void> toggleFavorite(String tripId) => _favorites.toggle(tripId);

  // ---------------- Filter state ----------------
  final RxSet<String> selectedLocations = <String>{}.obs;
  final RxSet<String> selectedTypes = <String>{}.obs;
  final RxnString selectedDuration = RxnString(); // '1-3' | '4-7' | '8+'
  final Rx<RangeValues> priceRange = const RangeValues(0, 100000).obs;

  double minPriceBound = 0;
  double maxPriceBound = 100000;

  final Rx<SortOption> sortOption = SortOption.popularity.obs;

  final RxList<String> availableLocations = <String>[].obs;
  final RxList<String> availableTypes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final trips = await TripService.getAllTrips();
      _allTrips.value = trips;

      availableLocations.value = trips.map((t) => t.location).where((l) => l.isNotEmpty).toSet().toList()..sort();
      availableTypes.value = trips.map((t) => t.type).where((t) => t.isNotEmpty).toSet().toList()..sort();

      if (trips.isNotEmpty) {
        final prices = trips.map((t) => t.price).toList();
        minPriceBound = prices.reduce((a, b) => a < b ? a : b);
        maxPriceBound = prices.reduce((a, b) => a > b ? a : b);
        if (minPriceBound == maxPriceBound) maxPriceBound += 1;
        priceRange.value = RangeValues(minPriceBound, maxPriceBound);
      }

      _applyFilters();
    } catch (e, st) {
      print('ExploreController.fetchTrips ERROR: $e');
      // ignore: avoid_print
      print(st);
      hasError.value = true;
      _allTrips.value = [];
      filteredTrips.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => fetchTrips();

  void toggleLocation(String location) {
    selectedLocations.contains(location)
        ? selectedLocations.remove(location)
        : selectedLocations.add(location);
    _applyFilters();
  }

  void toggleType(String type) {
    selectedTypes.contains(type) ? selectedTypes.remove(type) : selectedTypes.add(type);
    _applyFilters();
  }

  void setDurationBucket(String bucket) {
    selectedDuration.value = selectedDuration.value == bucket ? null : bucket;
    _applyFilters();
  }

  void setPriceRange(RangeValues range) {
    priceRange.value = range;
    _applyFilters();
  }

  void setSort(SortOption option) {
    sortOption.value = option;
    _applyFilters();
  }

  void resetFilters() {
    selectedLocations.clear();
    selectedTypes.clear();
    selectedDuration.value = null;
    priceRange.value = RangeValues(minPriceBound, maxPriceBound);
    _applyFilters();
  }

  int get activeFilterCount =>
      selectedLocations.length +
          selectedTypes.length +
          (selectedDuration.value != null ? 1 : 0) +
          (priceRange.value.start != minPriceBound || priceRange.value.end != maxPriceBound ? 1 : 0);

  bool _matchesDuration(int duration, String bucket) {
    switch (bucket) {
      case '1-3':
        return duration >= 1 && duration <= 3;
      case '4-7':
        return duration >= 4 && duration <= 7;
      case '8+':
        return duration >= 8;
      default:
        return true;
    }
  }

  void _applyFilters() {
    var result = _allTrips.where((trip) {
      final matchesSearch = searchQuery.value.trim().isEmpty ||
          trip.title.toLowerCase().contains(searchQuery.value.trim().toLowerCase()) ||
          trip.location.toLowerCase().contains(searchQuery.value.trim().toLowerCase());
      final matchesCategory = selectedCategory.value == 'All' ||
          trip.type.toLowerCase().contains(selectedCategory.value.toLowerCase()) ||
          trip.title.toLowerCase().contains(selectedCategory.value.toLowerCase());
      final matchesLocation = selectedLocations.isEmpty ||
          selectedLocations.any((loc) => trip.location.toLowerCase().contains(loc.toLowerCase()));
      final matchesType = selectedTypes.isEmpty || selectedTypes.contains(trip.type);
      final matchesDuration = selectedDuration.value == null || _matchesDuration(trip.duration, selectedDuration.value!);
      final matchesPrice = trip.price >= priceRange.value.start && trip.price <= priceRange.value.end;
      return matchesLocation && matchesType && matchesDuration && matchesPrice && matchesSearch && matchesCategory;
    }).toList();

    switch (sortOption.value) {
      case SortOption.priceLowHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.duration:
        result.sort((a, b) => a.duration.compareTo(b.duration));
        break;
      case SortOption.popularity:
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case SortOption.newest:
        result.sort(
              (a, b) => (b.createdAt ?? DateTime(2000)).compareTo(a.createdAt ?? DateTime(2000)),
        );
        break;
      case SortOption.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    filteredTrips.value = result;
  }

  // ---------------- Category state ----------------
  final RxString selectedCategory = 'All'.obs;

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  // ---------------- Search state ----------------
  final RxString searchQuery = ''.obs;

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }
}