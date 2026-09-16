import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/home/screens/trips_list_screen.dart';
import '../../../core/utils/cloudinary_utils.dart';
import '../../tripdetails/screens/trip_detail_screen.dart';
import '../controllers/home_controller.dart';
import '../widget/blog_card_horizontal.dart';
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
            final trips = controller.featuredTrips;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              for (final trip in trips.take(4)) {
                if (trip.coverImage.isNotEmpty) {
                  precacheImage(
                    CachedNetworkImageProvider(optimizedCloudinaryUrl(trip.coverImage, width: 360)),
                    context,
                  );
                }
              }
            });
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
                            onCtaTap: () => Get.to(() => const TripsListScreen(mode: TripListMode.all)),
                            onClose: () => controller.banner.value = null,
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
                        // ===== Featured Trips =====
                        if (controller.featuredTrips.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.md),
                          SectionHeader(
                            title: 'Featured Trips',
                            onSeeAll: () => Get.to(() => const TripsListScreen(mode: TripListMode.featured)),
                          ),
                          const SizedBox(height: AppSizes.sm + 2),
                          SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: min(3, controller.featuredTrips.length),
                              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
                              itemBuilder: (_, i) {
                                final trip = controller.featuredTrips[i];
                                return FeaturedTripCard(
                                  trip: trip,
                                  badgeText: 'Featured',
                                  badgeColor: AppColors.primary,
                                  onTap: () => Get.to(() => TripDetailScreen(tripId: trip.id)),
                                );
                              },
                            ),
                          ),
                        ],

                        // ===== Upcoming Trips =====
                        if (controller.upcomingTrips.isNotEmpty) ...[
                          const SizedBox(height: AppSizes.md),
                          SectionHeader(
                            title: 'Upcoming Trips',
                            onSeeAll: () => Get.to(() => const TripsListScreen(mode: TripListMode.upcoming)),
                          ),
                          const SizedBox(height: AppSizes.sm + 2),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: min(3, controller.upcomingTrips.length),
                            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
                            itemBuilder: (_, i) {
                              final trip = controller.upcomingTrips[i];
                              return UpcomingTripListTile(
                                trip: trip,
                                onTap: () => Get.to(() => TripDetailScreen(tripId: trip.id)),
                              );
                            },
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
