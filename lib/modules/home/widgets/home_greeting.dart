import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class HomeGreeting extends StatelessWidget {
  final String greeting;
  const HomeGreeting({super.key, required this.greeting});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSizes.xs),
        RichText(
          text: TextSpan(
            style: theme.textTheme.displayLarge,
            children: const [
              TextSpan(text: 'Discover\n'),
              TextSpan(text: 'Beautiful Places', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
      ],
    );
  }
}