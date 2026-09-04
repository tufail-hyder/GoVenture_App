import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/home/widget/section_header.dart';
import '../../customtours/screens/customize_tour_screen.dart';
import '../../tripdetails/screens/trip_detail_screen.dart';
import '../controllers/explore_controller.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/tour_list_card.dart';
import '../widgets/explore_filter_sheet.dart';
import '../widgets/explore_sort_sheet.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_theme.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final ExploreController controller;
  late final TextEditingController searchController;
  final FocusNode _searchFocusNode = FocusNode();

  static const List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Adventure', 'icon': Icons.terrain_rounded},
    {'label': 'Workcation', 'icon': Icons.laptop_mac_rounded},
    {'label': 'Retreat', 'icon': Icons.spa_rounded},
    {'label': 'Cultural', 'icon': Icons.account_balance_rounded},
    {'label': 'Family', 'icon': Icons.groups_rounded},
    {'label': 'Honeymoon', 'icon': Icons.favorite_border_rounded},
    {'label': 'Seasonal', 'icon': Icons.ac_unit_rounded},
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ExploreController>()
        ? Get.find<ExploreController>()
        : Get.put(ExploreController());
    searchController = TextEditingController(text: controller.searchQuery.value);
    _searchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _resetEverything() {
    controller.selectCategory('All');
    controller.setSearchQuery('');
    searchController.clear();
    controller.resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppSizes.md,
        title: const Text(
          'Tours',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimaryLight),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.md),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimaryLight),
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSizes.sm),

            // ---- Search bar with inline filter + sort icons ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  border: Border.all(
                    color: _searchFocusNode.hasFocus ? AppColors.primary : AppColors.dividerLight,
                    width: _searchFocusNode.hasFocus ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: _searchFocusNode.hasFocus ? AppColors.primary : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        focusNode: _searchFocusNode,
                        onChanged: controller.setSearchQuery,
                        decoration: const InputDecoration(
                          hintText: 'Search tours',
                          hintStyle: TextStyle(fontSize: 15, color: AppColors.textSecondaryLight),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimaryLight),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.bottomSheet(const ExploreSortSheet(), isScrollControlled: true),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.swap_vert_rounded, size: 20, color: AppColors.textPrimaryLight),
                      ),
                    ),
                    Container(height: 18, width: 1, color: AppColors.dividerLight, margin: const EdgeInsets.symmetric(horizontal: 4)),
                    InkWell(
                      onTap: () => Get.bottomSheet(const ExploreFilterSheet(), isScrollControlled: true),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Obx(() => Badge(
                          isLabelVisible: controller.activeFilterCount > 0,
                          label: Text('${controller.activeFilterCount}'),
                          backgroundColor: AppColors.primary,
                          child: const Icon(Icons.tune_rounded, size: 20, color: AppColors.primary),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // ---- Customize Your Own Tour — entry point banner ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: InkWell(
                onTap: () => Get.to(() => const CustomizeTourScreen()),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_calendar_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: AppSizes.sm + 2),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Plan Your Own Tour',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Tell us your preferences and we\'ll design it for you',
                              style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 24),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // ---- Browse by Category ----
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SectionHeader(title: 'Browse by Category'),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final label = cat['label'] as String;
                  return Obx(() => CategoryChip(
                    icon: cat['icon'] as IconData,
                    label: label,
                    isSelected: controller.selectedCategory.value == label,
                    onTap: () => controller.selectCategory(label),
                  ));
                },
              ),
            ),

            const SizedBox(height: AppSizes.md),

            // ---- All Tours / <Category> Tours heading — changes with category ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Obx(() => SectionHeader(
                  title:  controller.selectedCategory.value == 'All'
                      ? 'All Tours'
                      : '${controller.selectedCategory.value} Tours',
                )),
              ),
            ),

            // ---- Result count once filters/search/category active ----
            Obx(() {
              final hasSearch = controller.searchQuery.value.trim().isNotEmpty;
              final hasCategory = controller.selectedCategory.value != 'All';
              if (controller.activeFilterCount == 0 && !hasSearch && !hasCategory) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${controller.filteredTrips.length} tours found',
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }),
            const SizedBox(height: AppSizes.sm),

            // ---- List ----
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ---- Firestore fetch failed (network/permissions/etc) ----
                if (controller.hasError.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.textSecondaryLight),
                          const SizedBox(height: AppSizes.sm),
                          const Text(
                            'Couldn\'t load tours',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimaryLight),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Please check your internet connection and try again.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                          ),
                          const SizedBox(height: AppSizes.md),
                          ElevatedButton(
                            onPressed: controller.refresh,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // ---- No trips match filters, or Firestore genuinely has none ----
                if (controller.filteredTrips.isEmpty) {
                  return EmptyState(onReset: _resetEverything);
                }

                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(AppSizes.md, 0, AppSizes.md, AppSizes.xl),
                    itemCount: controller.filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = controller.filteredTrips[index];
                      return Obx(() => TourListCard(
                        trip: trip,
                        isFavorite: controller.favoriteTripIds.contains(trip.id),
                        onTap: () => Get.to(() => TripDetailScreen(tripId: trip.id)),
                        onFavoriteTap: () => controller.toggleFavorite(trip.id),
                      ));
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}