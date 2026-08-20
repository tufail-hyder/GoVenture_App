import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TripSectionTitle extends StatelessWidget {
  final String title;
  const TripSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimaryLight),
    );
  }
}