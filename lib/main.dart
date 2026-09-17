import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goventure/modules/onboarding/screens/onboarding_screen.dart';
import 'package:goventure/modules/auth/screens/login_screen.dart';
import 'package:goventure/modules/root/root_screen.dart';
import 'package:goventure/seed.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'modules/favourite/controllers/favorites_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(FavoritesController(), permanent: true);

  // ===== ONE-TIME SEED: About Us content =====
  // Runs only if appSettings/aboutUs doesn't have this flag set yet, so it
  // won't re-run (and won't overwrite your later Firestore edits) on every
  // launch. Remove this whole block (and the import above) once you've
  // confirmed the About Us screen shows the content correctly.
  final seedBox = GetStorage();
  final aboutUsSeeded = seedBox.read('aboutUsSeeded') ?? false;
  if (!aboutUsSeeded) {
    try {
      await AboutUsSeeder.seedAboutUs();
      await seedBox.write('aboutUsSeeded', true);
    } catch (e) {
      // Most likely cause: appSettings write rule is still `false` in
      // Firestore rules. Temporarily set it to `true`, run once, then
      // set it back to `false`.
      debugPrint('About Us seed failed: $e');
    }
  }
  // ===== END ONE-TIME SEED =====

  final storage = GetStorage();
  final isFirstTime = storage.read('IsFirstTime') ?? true;
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  final Widget startScreen = isFirstTime
      ? const OnboardingScreen()
      : (isLoggedIn ? const RootScreen() : LoginScreen());

  runApp(GoVentureApp(startScreen: startScreen));
}

class GoVentureApp extends StatelessWidget {
  const GoVentureApp({super.key, required this.startScreen});

  final Widget startScreen;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: startScreen,
    );
  }
}