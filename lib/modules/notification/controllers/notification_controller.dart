import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../model/notification_model.dart';
import '../services/notification_data_services.dart';

class NotificationController extends GetxController {
  static const _lastSeenKey = 'lastSeenNotificationsAt';

  final notifications = <NotificationModel>[].obs;
  final isLoading = true.obs;
  final unreadCount = 0.obs;

  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final items = await NotificationDataService.getRecent();
      notifications.assignAll(items);
      _recalculateUnread();
    } finally {
      isLoading.value = false;
    }
  }

  void _recalculateUnread() {
    final lastSeenMillis = _storage.read<int>(_lastSeenKey) ?? 0;
    final lastSeen = DateTime.fromMillisecondsSinceEpoch(lastSeenMillis);
    unreadCount.value = notifications
        .where((n) => n.createdAt != null && n.createdAt!.isAfter(lastSeen))
        .length;
  }

  void markAllSeen() {
    _storage.write(_lastSeenKey, DateTime.now().millisecondsSinceEpoch);
    unreadCount.value = 0;
  }

  Future<void> refresh() => loadNotifications();
}