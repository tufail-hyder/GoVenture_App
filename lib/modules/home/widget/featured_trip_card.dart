import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../favourite/services/favourite_services.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../services/review_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/cloudinary_utils.dart';
import 'dart:ui';

class FeaturedTripCard extends StatefulWidget {
  final TripModel trip;
  final String badgeText;
  final Color badgeColor;
  final VoidCallback onTap;

  const FeaturedTripCard({
    super.key,
    required this.trip,
    required this.badgeText,
    required this.badgeColor,
    required this.onTap,
  });

  @override
  State<FeaturedTripCard> createState() => _FeaturedTripCardState();
}

class _FeaturedTripCardState extends State<FeaturedTripCard> {
  bool _isFavorite = false;
  double _liveRating = 0;
  int _liveReviewCount = 0;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _loadLiveRating();
  }

  Future<void> _loadFavoriteStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final fav = await FavoritesService.isFavorite(uid, widget.trip.id);
    if (mounted) setState(() => _isFavorite = fav);
  }

  Future<void> _loadLiveRating() async {
    try {
      final reviews = await ReviewService.getReviewsForTrip(widget.trip.id);
      if (!mounted || reviews.isEmpty) return;
      setState(() {
        _liveRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
        _liveReviewCount = reviews.length;
      });
    } catch (_) {
      // Fail silently — card sirf rating na dikhaye, crash na ho
    }
  }

  Future<void> _toggleFavorite() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first to add favorites')),
      );
      return;
    }
    setState(() => _isFavorite = !_isFavorite);
    await FavoritesService.toggleFavorite(uid: uid, tripId: widget.trip.id);
  }

  ({String label, IconData icon, Color color})? _resolveBadge() {
    final trip = widget.trip;

    // Top Rated: high rating + kaafi reviews ho
    if (_liveReviewCount >= 15 && _liveRating >= 4.5) {
      return (label: 'Top Rated', icon: Icons.workspace_premium_rounded, color: const Color(0xFFE0A415));
    }

    // Popular: decent review volume
    if (_liveReviewCount >= 8) {
      return (label: 'Popular', icon: Icons.local_fire_department_rounded, color: const Color(0xFFE0512F));
    }

    final originalPrice = trip.originalPrice;
    if (originalPrice != null && originalPrice > trip.price) {
      final discountPercent =
      (((originalPrice - trip.price) / originalPrice) * 100).round();
      if (discountPercent >= 10) {
        return (
        label: '$discountPercent% Off',
        icon: Icons.sell_rounded,
        color: const Color(0xFFD0342C),
        );
      }
    }

    if (trip.createdAt != null &&
        DateTime.now().difference(trip.createdAt!).inDays <= 14) {
      return (
      label: 'New',
      icon: Icons.fiber_new_rounded,
      color: const Color(0xFF2F6FED),
      );
    }

    // Best Seller: agar trip explicitly featured/marked hai
    if (widget.trip.isFeatured) {
      return (label: 'Best Seller', icon: Icons.star_rounded, color: AppColors.primary);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final trip = widget.trip;
    final nights = trip.duration > 0 ? trip.duration - 1 : 0;
    final badge = _resolveBadge();

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: scheme.outline.withValues(alpha: 0.10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 110,
                  width: double.infinity,
                  child: trip.coverImage.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: optimizedCloudinaryUrl(trip.coverImage, width: 360),
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 150),
                    placeholder: (context, url) => Container(color: Colors.grey.shade200),
                    errorWidget: (context, url, error) => Container(color: Colors.grey.shade300),
                  )
                      : Container(color: Colors.grey.shade300),
                ),

                // Halka gradient overlay taake badge/icon image ke upar bhi readable rahe
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4],
                      ),
                    ),
                  ),
                ),

                // ===== Dynamic Badge (glass/blur pill) =====
                if (badge != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: badge.color.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                            boxShadow: [
                              BoxShadow(
                                color: badge.color.withValues(alpha: 0.35),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(badge.icon, size: 11, color: Colors.white),
                              const SizedBox(width: 3),
                              Text(
                                badge.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // ===== Favorite button (glass background) =====
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleFavorite,
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.75),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 16,
                            color: _isFavorite ? Colors.redAccent : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(AppSizes.sm + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: scheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.bookmark_border_rounded, size: 14, color: scheme.onSurface.withValues(alpha: 0.6)),
                      const SizedBox(width: 3),
                      Text(
                        '${trip.duration} Days · $nights Nights',
                        style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.directions_walk_rounded, size: 14, color: scheme.onSurface.withValues(alpha: 0.6)),
                      const SizedBox(width: 3),
                      Text(
                        _capitalize(trip.type),
                        style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.xs),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PKR ${trip.price.toStringAsFixed(0)}',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (_liveReviewCount > 0)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              _liveRating.toStringAsFixed(1),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scheme.onSurface),
                            ),
                            Text(
                              ' ($_liveReviewCount)',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: scheme.onSurface.withValues(alpha: 0.6)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String text) => text.isEmpty ? '' : text[0].toUpperCase() + text.substring(1);
}