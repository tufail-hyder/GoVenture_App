import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/home/widget/section_header.dart';
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
    controller = Get.put(ExploreController());
    searchController = TextEditingController(text: controller.searchQuery.value);
  }

  @override
  void dispose() {
    searchController.dispose();
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
                  border: Border.all(color: AppColors.dividerLight),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondaryLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: controller.setSearchQuery,
                        decoration: const InputDecoration(
                          hintText: 'Search tours',
                          hintStyle: TextStyle(fontSize: 15, color: AppColors.textSecondaryLight),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
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
                        onTap: () {
                          // TODO: navigate to Trip Detail screen once it exists.
                        },
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
