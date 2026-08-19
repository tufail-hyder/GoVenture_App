import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'admin/modules/auth/admin_login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GoVentureAdminApp());
}

class GoVentureAdminApp extends StatelessWidget {
  const GoVentureAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GoVenture Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AdminLoginScreen(),
    );
  }
}