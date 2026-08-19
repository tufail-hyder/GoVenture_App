import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goventure/modules/explore/screens/explore_screen.dart';
import '../home/screens/home_screen.dart';
import '../auth/controllers/auth_controller.dart';
import '../../core/constants/app_icons.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const Center(child: Text('Bookings')),
      const Center(child: Text('Saved')),
      // Obx(() => authController.isLoggedIn ? const ProfileScreen() : LoginScreen()),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(AppIcons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(AppIcons.bookings), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(AppIcons.profile), label: 'Profile'),
        ],
      ),
    );
  }
}