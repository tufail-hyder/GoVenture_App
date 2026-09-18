import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CurvedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final IconData homeIcon;
  final IconData exploreIcon;
  final IconData centerIcon;
  final IconData savedIcon;
  final IconData profileIcon;

  const CurvedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.homeIcon,
    required this.exploreIcon,
    required this.centerIcon,
    required this.savedIcon,
    required this.profileIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? AppColors.surfaceDark : Colors.white;

    return SizedBox(
      height: 76,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ===== Bar itself =====
          Container(
            height: 76,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: _NavItem(icon: homeIcon, label: 'Home', index: 0, currentIndex: currentIndex, onTap: onTap)),
                Expanded(child: _NavItem(icon: exploreIcon, label: 'Explore', index: 1, currentIndex: currentIndex, onTap: onTap)),
                const SizedBox(width: 66),
                Expanded(child: _NavItem(icon: savedIcon, label: 'Saved', index: 3, currentIndex: currentIndex, onTap: onTap)),
                Expanded(child: _NavItem(icon: profileIcon, label: 'Profile', index: 4, currentIndex: currentIndex, onTap: onTap)),
              ],
            ),
          ),

          // ===== Floating center button =====
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(color: barColor, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(centerIcon, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final scheme = Theme.of(context).colorScheme;
    final color = isSelected ? AppColors.primary : scheme.onSurface.withValues(alpha: 0.45);

    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}