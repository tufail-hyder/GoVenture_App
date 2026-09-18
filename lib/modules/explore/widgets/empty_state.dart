import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({required this.onReset});
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off_rounded, size: 48, color: AppColors.textSecondaryLight),
                  const SizedBox(height: AppSizes.sm),
                  const Text('No tours match your filters', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: AppSizes.xs),
                  const Text(
                    'Try adjusting or resetting your filters.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondaryLight),
                  ),
                  const SizedBox(height: AppSizes.md),
                  TextButton(
                    onPressed: onReset,
                    child: const Text('Reset Filters', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}