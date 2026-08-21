import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class TripImageCarousel extends StatefulWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const TripImageCarousel({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
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