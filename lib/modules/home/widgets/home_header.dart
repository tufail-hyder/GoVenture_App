import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_sizes.dart';

/// Top row of the Home screen.
///
/// The [AppImages.appLightLogo] asset already contains the mountain mark +
/// "Goventure.pk" wordmark + tagline baked in as one image — so this
/// widget just places that single asset next to the notification bell.
/// Do NOT add a separate "GoVenture" Text widget next to it.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.hasUnreadNotifications = false,
    this.onNotificationTap,
  });

  final bool hasUnreadNotifications;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final iconColor =
    isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.appLightLogo,
          height: 46,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        _NotificationButton(
          surface: surface,
          iconColor: iconColor,
          hasUnread: hasUnreadNotifications,
          onTap: onNotificationTap,
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    required this.surface,
    required this.iconColor,
    required this.hasUnread,
    this.onTap,
  });

  final Color surface;
  final Color iconColor;
  final bool hasUnread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: surface,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.notifications_none_rounded,
                color: iconColor,
                size: AppSizes.iconMd,
              ),
            ),
            if (hasUnread)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}