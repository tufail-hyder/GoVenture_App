import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

Future<bool?> showWriteReviewSheet(
    BuildContext context, {
      double? initialRating,
      String? initialComment,
      required Future<void> Function(double rating, String comment) onSubmit,
      Future<void> Function()? onDelete,
    }) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _WriteReviewSheet(
      initialRating: initialRating,
      initialComment: initialComment,
      onSubmit: onSubmit,
      onDelete: onDelete,
    ),
  );
}

class _WriteReviewSheet extends StatefulWidget {
  const _WriteReviewSheet({
    this.initialRating,
    this.initialComment,
    required this.onSubmit,
    this.onDelete,
  });

  final double? initialRating;
  final String? initialComment;
  final Future<void> Function(double rating, String comment) onSubmit;
  final Future<void> Function()? onDelete;

  bool get isEditing => initialRating != null;

  @override
  State<_WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<_WriteReviewSheet> {
  late int _rating = widget.initialRating?.round() ?? 0;
  late final _commentCtrl = TextEditingController(text: widget.initialComment ?? '');
  bool _isSubmitting = false;
  bool _isDeleting = false;
  String? _error;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      setState(() => _error = 'Please select a star rating');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await widget.onSubmit(_rating.toDouble(), _commentCtrl.text.trim());
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _error = 'Could not save your review. Please try again.';
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        title: const Text('Delete review?'),
        content: const Text('This will permanently remove your review. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed != true || widget.onDelete == null) return;

    setState(() => _isDeleting = true);
    try {
      await widget.onDelete!();
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
          _error = 'Could not delete your review. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimaryLight;
    final textSecondary = isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final fieldFill = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final busy = _isSubmitting || _isDeleting;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, AppSizes.md),
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSizes.md),
                decoration: BoxDecoration(color: textSecondary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEditing ? 'Edit Your Review' : 'Write a Review',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textPrimary),
                ),
                if (widget.isEditing && widget.onDelete != null)
                  IconButton(
                    onPressed: busy ? null : _confirmDelete,
                    icon: _isDeleting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    tooltip: 'Delete review',
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.md),

            Text('Your rating', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textSecondary)),
            const SizedBox(height: 6),
            Row(
              children: List.generate(5, (i) {
                final starIndex = i + 1;
                return GestureDetector(
                  onTap: busy ? null : () => setState(() {
                    _rating = starIndex;
                    _error = null;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      starIndex <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 34,
                      color: Colors.amber,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSizes.md),

            Text('Your review (optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textSecondary)),
            const SizedBox(height: 6),
            TextField(
              controller: _commentCtrl,
              maxLines: 4,
              style: TextStyle(fontSize: 14, color: textPrimary),
              decoration: InputDecoration(
                hintText: 'Share your experience with this trip...',
                hintStyle: TextStyle(fontSize: 13.5, color: textSecondary),
                filled: true,
                fillColor: fieldFill,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: textSecondary.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: textSecondary.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),



            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(fontSize: 12.5, color: Colors.redAccent, fontWeight: FontWeight.w600)),
            ],

            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: busy ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                    : Text(widget.isEditing ? 'Update Review' : 'Submit Review',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }
}