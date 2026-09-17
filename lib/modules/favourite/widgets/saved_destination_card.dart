import 'package:flutter/material.dart';
import '../../home/models/destination_model.dart';
import '../../../core/constants/app_sizes.dart';

class SavedDestinationCard extends StatelessWidget {
  final DestinationModel destination;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const SavedDestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: destination.coverImage.isNotEmpty
                  ? Image.network(destination.coverImage, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300))
                  : Container(color: Colors.grey.shade300),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(destination.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: scheme.onSurface)),
                    if (destination.location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, size: 13, color: scheme.onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(destination.location, maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12.5, color: scheme.onSurface.withValues(alpha: 0.65))),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.favorite_rounded, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}