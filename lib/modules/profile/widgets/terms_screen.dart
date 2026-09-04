import 'package:flutter/material.dart';
import '../../tripdetails/models/trip_terms_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class TermsScreen extends StatelessWidget {
  final String title;
  final Future<TermsModel> Function() fetcher;

  const TermsScreen({super.key, required this.title, required this.fetcher});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: FutureBuilder<TermsModel>(
        future: fetcher(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final terms = snapshot.data;
          if (terms == null || terms.content.isEmpty) {
            return Center(
              child: Text('Content not available yet.', style: TextStyle(color: textSecondary)),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Text(
              terms.content,
              style: TextStyle(fontSize: 14, height: 1.6, color: textPrimary),
            ),
          );
        },
      ),
    );
  }
}