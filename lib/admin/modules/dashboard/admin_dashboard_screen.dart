import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../auth/admin_login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoVenture Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.signOut();
              Get.offAll(() => const AdminLoginScreen());
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Trips / Banners / Blogs management yahan aayega — Step 5 mein banayenge'),
      ),
    );
  }
}