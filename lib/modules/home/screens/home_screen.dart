import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../tripdetails/screens/trip_detail_screen.dart';
import '../controllers/home_controller.dart';
import '../widget/blog_card_horizontal.dart';
import '../widget/category_grid.dart';
import '../widget/destination_mini_card.dart';
import '../widget/featured_trip_card.dart';
import '../widget/home_hero_header.dart';
import '../widget/seasonal_banner_strip.dart';
import '../widget/upcoming_trip_list_tile.dart';
import '../widget/section_header.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import 'all_destinations_screen.dart';
import 'destination_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          top: false,
          child: Obx(() {

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // ===== Hero Header (logo, bell, greeting, headline, search bar) =====
                  HomeHeroHeader(
                    greeting: controller.greeting.value,
                    onFilterTap: () {
                    },
                    onSearchSubmitted: (query) {},
                  ),

                  const SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ===== Seasonal Announcement Banner =====
                        if (controller.banner.value != null) ...[
                          SeasonalBannerStrip(
                            banner: controller.banner.value!,
                            onCtaTap: () {},
                          ),
                        ],


                        // ===== Featured Destinations =====
                        if (controller.popularDestinations.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.md),
                          SectionHeader(
                            title: 'Popular Destinations',
                            onSeeAll: () => Get.to(() => const AllDestinationsScreen()),
                          ),
                          const SizedBox(height: AppSizes.sm + 2),
                          SizedBox(
                            height: 170,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: min(3, controller.popularDestinations.length),
                              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
                              itemBuilder: (_, i) => SizedBox(
                                width: 140,
                                child: DestinationMiniCard(
                                  destination: controller.popularDestinations[i],
                                  onTap: () => Get.to(() => DestinationDetailScreen(
                                    destinationId: controller.popularDestinations[i].id,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],

                        // ===== Upcoming Trips =====
                        if (controller.upcomingBookings.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.md),
                          SectionHeader(title: 'Upcoming Trips', onSeeAll: () {}),
                          const SizedBox(height: AppSizes.sm + 2),
                          SizedBox(
                            height: 260,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.upcomingBookings.length,
                              separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
                              itemBuilder: (_, i) => UpcomingTripListTile(
                                booking: controller.upcomingBookings[i],
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSizes.md),
                        // ===== Category Grid =====
                        SectionHeader(title: 'Trip Categories'),
                        const SizedBox(height: AppSizes.sm + 2),
                        CategoryGrid(
                          items: [
                            CategoryGridItem(
                              title: 'Workcation',
                              subtitle: '${controller.workcationTrips.length} Trips',
                              icon: Icons.laptop_mac_rounded,
                              bgColor: AppColors.primaryLight,
                              iconColor: AppColors.primary,
                              onTap: () {},
                            ),
                            CategoryGridItem(
                              title: 'Adventure',
                              subtitle: '${controller.adventureTrips.length} Trips',
                              icon: Icons.terrain_rounded,
                              bgColor: AppColors.accentBlueLight,
                              iconColor: AppColors.accentBlue,
                              onTap: () {},
                            ),
                            CategoryGridItem(
                              title: 'Retreats',
                              subtitle: '${controller.retreatTrips.length} Trips',
                              icon: Icons.spa_rounded,
                              bgColor: AppColors.accentPurpleLight,
                              iconColor: AppColors.accentPurple,
                              onTap: () {},
                            ),
                          ],
                        ),

                        // ===== Featured Trips =====
                        if (controller.featuredTrips.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.md),
                          SectionHeader(title: 'Featured Trips', onSeeAll: () {}),
                          const SizedBox(height: AppSizes.sm + 2),
                          SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.featuredTrips.length,
                              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
                              itemBuilder: (_, i) {
                                const badges = [
                                  ('Best Seller', AppColors.primary),
                                  ('Top Rated', AppColors.accentPurple),
                                  ('Popular', AppColors.warning),
                                ];
                                final badge = badges[i % badges.length];
                                return FeaturedTripCard(
                                  trip: controller.featuredTrips[i],
                                  badgeText: badge.$1,
                                  badgeColor: badge.$2,
                                  onTap: () => Get.to(() => TripDetailScreen(tripId: controller.featuredTrips[i].id)),
                                );
                              },
                            ),
                          ),
                        ],

                        // ===== From the Blog =====
                        if (controller.blogPosts.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.md),
                          SectionHeader(
                            title: 'Latest from Our Blog',
                            onSeeAll: () {},
                          ),
                          const SizedBox(height: AppSizes.sm + 2),
                          SizedBox(
                            height: 140,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.blogPosts.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(width: AppSizes.sm),
                              itemBuilder: (_, i) => BlogCardHorizontal(
                                blog: controller.blogPosts[i],
                                onTap: () {},
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSizes.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
