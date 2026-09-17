import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_sizes.dart';
import '../../favourite/services/favourite_services.dart';
import '../models/destination_model.dart';

class DestinationMiniCard extends StatefulWidget {
  final DestinationModel destination;
  final VoidCallback onTap;

  const DestinationMiniCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  @override
  State<DestinationMiniCard> createState() => _DestinationMiniCardState();
}

class _DestinationMiniCardState extends State<DestinationMiniCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final fav = await FavoritesService.isFavoriteDestination(uid, widget.destination.id);
    if (mounted) setState(() => _isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to save favorites')),
      );
      return;
    }
    setState(() => _isFavorite = !_isFavorite); // optimistic
    await FavoritesService.toggleFavoriteDestination(uid: uid, destinationId: widget.destination.id);
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            destination.coverImage.isNotEmpty
                ? Image.network(
              destination.coverImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade400),
            )
                : Container(color: Colors.grey.shade400),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                  stops: [0.4, 1.0],
                ),
              ),
            ),

            // ===== Favorite (heart) icon — ab kaam karta hai =====
            Positioned(
              top: AppSizes.sm,
              right: AppSizes.sm,
              child: GestureDetector(
                onTap: _toggleFavorite,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 18,
                    color: _isFavorite ? Colors.redAccent : Colors.white,
                  ),
                ),
              ),
            ),

            Positioned(
              left: AppSizes.sm,
              right: AppSizes.sm,
              bottom: AppSizes.sm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    destination.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    destination.location,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}