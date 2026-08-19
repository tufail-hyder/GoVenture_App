// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../auth/controllers/auth_controller.dart';
// import '../../../core/constants/app_sizes.dart';
// import '../../../core/constants/app_icons.dart';
//
// const _placeholderImage = 'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   Widget _providerIcon(User user) {
//     final providers = user.providerData.map((e) => e.providerId).toList();
//     if (providers.contains('google.com')) return const Icon(Icons.g_mobiledata, size: AppSizes.iconMd);
//     if (providers.contains('apple.com')) return const Icon(Icons.apple, size: AppSizes.iconMd);
//     return const SizedBox.shrink();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AuthController>();
//     final theme = Theme.of(context);
//
//     return Obx(() {
//       final user = controller.currentUser.value;
//       if (user == null) return const SizedBox.shrink(); // RootScreen handle karega
//
//       return Scaffold(
//         appBar: AppBar(title: const Text('Profile')),
//         body: Padding(
//           padding: const EdgeInsets.all(AppSizes.lg),
//           child: Column(
//             children: [
//               const SizedBox(height: AppSizes.md),
//               CircleAvatar(radius: 50, backgroundImage: NetworkImage(user.photoURL ?? _placeholderImage)),
//               const SizedBox(height: AppSizes.md),
//               Text(user.displayName ?? 'GoVenture User', style: theme.textTheme.titleMedium),
//               const SizedBox(height: AppSizes.xs),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Flexible(child: Text(user.email ?? '', style: theme.textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
//                   const SizedBox(width: AppSizes.xs),
//                   _providerIcon(user),
//                 ],
//               ),
//               const SizedBox(height: AppSizes.xl),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(AppIcons.bookings),
//                 title: const Text('My Bookings'),
//                 trailing: const Icon(Icons.chevron_right),
//                 onTap: () {},
//               ),
//               const Divider(),
//               const SizedBox(height: AppSizes.xl),
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton.icon(
//                   icon: const Icon(Icons.logout, color: Colors.red),
//                   label: const Text('Sign Out', style: TextStyle(color: Colors.red)),
//                   style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
//                   onPressed: () => controller.signOut(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }