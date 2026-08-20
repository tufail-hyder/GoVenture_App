import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class TripImageCarousel extends StatefulWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onShareTap;
  final VoidCallback onBackTap;

  const TripImageCarousel({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onShareTap,
    required this.onBackTap,
  });

  @override
  State<TripImageCarousel> createState() => _TripImageCarouselState();
}

class _TripImageCarouselState extends State<TripImageCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isNotEmpty ? widget.images : [''];

    return Stack(
      children: [
        SizedBox(
          height: 320,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: widget.onPageChanged,
            itemCount: images.length,
            itemBuilder: (context, index) {
              final url = images[index];
              return url.isNotEmpty
                  ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
              )
                  : Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_outlined, size: 48, color: AppColors.textSecondaryLight),
              );
            },
          ),
        ),

        // ===== Top gradient (back/favorite/share icons readable rakhne ke liye) =====
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withValues(alpha: 0.45), Colors.transparent],
            ),
          ),
        ),

        // ===== Back button =====
        Positioned(
          top: AppSizes.md,
          left: AppSizes.md,
          child: _CircleIconButton(icon: Icons.arrow_back_rounded, onTap: widget.onBackTap),
        ),

        // ===== Favorite + Share buttons =====
        Positioned(
          top: AppSizes.md,
          right: AppSizes.md,
          child: Row(
            children: [
              _CircleIconButton(icon: Icons.ios_share_rounded, onTap: widget.onShareTap),
              const SizedBox(width: AppSizes.xs),
              _CircleIconButton(
                icon: widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                iconColor: widget.isFavorite ? AppColors.favoriteRed : Colors.white,
                onTap: widget.onFavoriteTap,
              ),
            ],
          ),
        ),

        // ===== Dot indicator =====
        if (images.length > 1)
          Positioned(
            bottom: AppSizes.md,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: images.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.white.withValues(alpha: 0.5),
                  dotHeight: 6,
                  dotWidth: 6,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, this.iconColor = Colors.white, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}