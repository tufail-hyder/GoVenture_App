import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/explore/screens/explore_screen.dart';
import 'package:goventure/modules/root/root_nav_controller.dart';
import '../favourite/screens/saved_trips_screen.dart';
import '../home/screens/home_screen.dart';
import '../auth/controllers/auth_controller.dart';
import '../../core/constants/app_icons.dart';
import '../mybookings/screens/my_bookings_screen.dart';
import '../profile/screens/profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final authController = Get.put(AuthController());
  final navController = Get.put(RootNavController());

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const MyBookingsScreen(),
      const SavedTripsScreen(),
      const ProfileScreen(),
    ];

    return Obx(() => Scaffold(
      body: IndexedStack(index: navController.currentIndex.value, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navController.currentIndex.value,
        onTap: navController.changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(AppIcons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(AppIcons.bookings), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(AppIcons.profile), label: 'Profile'),
        ],
      ),
    ));
  }
}