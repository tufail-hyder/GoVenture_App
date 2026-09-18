import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../controllers/explore_controller.dart';

class ExploreSortSheet extends StatelessWidget {
  const ExploreSortSheet({super.key});

  static const _options = {
    SortOption.priceLowHigh: 'Price: Low to High',
    SortOption.priceHighLow: 'Price: High to Low',
    SortOption.duration: 'Duration',
    SortOption.rating: 'Highest Rated',
    SortOption.popularity: 'Popularity',
    SortOption.newest: 'Newest',
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreController>();

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.dividerLight, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: AppSizes.md),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Sort By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Obx(() => Column(
              children: _options.entries.map((entry) {
                final selected = controller.sortOption.value == entry.key;
                return ListTile(
                  title: Text(
                    entry.value,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? AppColors.primary : AppColors.textPrimaryLight,
                    ),
                  ),
                  trailing: selected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                  onTap: () {
                    controller.setSort(entry.key);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }
}