import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../controllers/notification_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(NotificationController());
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.markAllSeen());
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'trip':
        return Icons.card_travel_rounded;
      case 'blog':
        return Icons.article_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.notifications_off_outlined, size: 48, color: scheme.onSurface.withValues(alpha: 0.4)),
                const SizedBox(height: AppSizes.sm),
                Text('No notifications yet', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6))),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.md),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (_, i) {
              final n = controller.notifications[i];
              return Container(
                padding: const EdgeInsets.all(AppSizes.sm + 2),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      child: Icon(_iconFor(n.type), color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(n.title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: scheme.onSurface)),
                          const SizedBox(height: 3),
                          Text(n.body, style: TextStyle(fontSize: 13, color: scheme.onSurface.withValues(alpha: 0.7))),
                          if (n.createdAt != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              DateFormat('MMM d, yyyy • h:mm a').format(n.createdAt!),
                              style: TextStyle(fontSize: 11, color: scheme.onSurface.withValues(alpha: 0.5)),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}