import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import '../../tripdetails/screens/trip_detail_screen.dart';
import '../models/destination_model.dart';
import '../services/destination_service.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../services/trip_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class DestinationDetailScreen extends StatefulWidget {
  final String destinationId;
  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final Future<DestinationModel?> _destinationFuture;
  bool _isFavorite = false;

  static const _tabs = [
    ('Overview', Icons.info_outline_rounded),
    ('Weather', Icons.thermostat_rounded),
    ('Tours', Icons.card_travel_rounded),
    ('Culture', Icons.temple_buddhist_outlined),
    ('Seasons', Icons.wb_sunny_outlined),
    ('Food', Icons.restaurant_outlined),
    ('Crafts', Icons.palette_outlined),
    ('People', Icons.groups_outlined),
    ('Attractions', Icons.photo_camera_outlined),
    ('Facts', Icons.lightbulb_outline_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _destinationFuture = DestinationService.getDestinationById(widget.destinationId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DestinationModel?>(
        future: _destinationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final dest = snapshot.data;
        if (dest == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Destination not found')),
          );
        }

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [
            SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: _CircleIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: _CircleIconButton(
                  icon: _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  iconColor: _isFavorite ? Colors.redAccent : Colors.white,
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      dest.coverImage.isNotEmpty
                          ? Image.network(
                        dest.coverImage,
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
                            stops: [0.35, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: AppSizes.md,
                        right: AppSizes.md,
                        bottom: AppSizes.md,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dest.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (dest.location.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 15, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      dest.location,
                                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (dest.elevation > 0) ...[
                                    const SizedBox(width: 10),
                                    const Icon(Icons.terrain_rounded, size: 15, color: Colors.white70),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${dest.elevation.toInt()} m',
                                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primary,
                    tabAlignment: TabAlignment.start,
                    tabs: _tabs.map((t) => Tab(icon: Icon(t.$2, size: 18), text: t.$1)).toList(),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _LazyTab(controller: _tabController, index: 0, builder: (_) => _OverviewTab(dest: dest)),
                _LazyTab(controller: _tabController, index: 1, builder: (_) => _WeatherTab(dest: dest)),
                _LazyTab(controller: _tabController, index: 2, builder: (_) => _ToursTab(destinationId: dest.id)),
                _LazyTab(
                  controller: _tabController,
                  index: 3,
                  builder: (_) => _SectionScaffold(
                    icon: Icons.temple_buddhist_outlined,
                    title: 'Culture & History',
                    child: _BodyText(dest.cultureHistory),
                  ),
                ),
                _LazyTab(
                  controller: _tabController,
                  index: 4,
                  builder: (_) => _SectionScaffold(
                    icon: Icons.wb_sunny_outlined,
                    title: 'Seasons',
                    child: _SeasonsList(seasons: dest.seasons),
                  ),
                ),
                _LazyTab(
                  controller: _tabController,
                  index: 5,
                  builder: (_) => _SectionScaffold(
                    icon: Icons.restaurant_outlined,
                    title: 'Food & Cuisines',
                    child: _NamedItemsList(intro: dest.foodIntro, items: dest.foodItems),
                  ),
                ),
                _LazyTab(
                  controller: _tabController,
                  index: 6,
                  builder: (_) => _SectionScaffold(
                    icon: Icons.palette_outlined,
                    title: 'Arts & Crafts',
                    child: _NamedItemsList(intro: dest.craftsIntro, items: dest.craftItems),
                  ),
                ),
                _LazyTab(
                  controller: _tabController,
                  index: 7,
                  builder: (_) => _SectionScaffold(
                    icon: Icons.groups_outlined,
                    title: 'Demographics',
                    child: _BodyText(dest.demographics),
                  ),
                ),
                _LazyTab(
                  controller: _tabController,
                  index: 8,
                  builder: (_) => _SectionScaffold(
                    icon: Icons.photo_camera_outlined,
                    title: 'Attractions',
                    child: _NamedItemsList(intro: '', items: dest.attractions),
                  ),
                ),
                _LazyTab(
                  controller: _tabController,
                  index: 9,
                  builder: (_) => _SectionScaffold(
                    icon: Icons.lightbulb_outline_rounded,
                    title: 'Interesting Facts',
                    child: _FactsList(facts: dest.interestingFacts),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

class _SectionScaffold extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _SectionScaffold({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final DestinationModel dest;
  const _OverviewTab({required this.dest});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasStats = dest.location.isNotEmpty || dest.elevation > 0;

    return _SectionScaffold(
      icon: Icons.info_outline_rounded,
      title: 'Overview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasStats) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (dest.location.isNotEmpty)
                  _StatChip(icon: Icons.location_on_rounded, label: dest.location),
                if (dest.elevation > 0)
                  _StatChip(icon: Icons.terrain_rounded, label: '${dest.elevation.toInt()} m elevation'),
              ],
            ),
            const SizedBox(height: 18),
          ],
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
            ),
            child: Text(
              dest.overview,
              style: TextStyle(fontSize: 15.5, height: 1.7, color: scheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: scheme.onSurface)),
        ],
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const _EmptyState(icon: Icons.article_outlined, label: 'No content yet');
    return Text(
      text,
      style: TextStyle(fontSize: 15, height: 1.6, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;
  const _EmptyState({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 40, color: onSurface.withValues(alpha: 0.35)),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(color: onSurface.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}

class _MediaCard extends StatelessWidget {
  final String image;
  final String name;
  final String description;
  const _MediaCard({required this.image, required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image.isNotEmpty)
            Image.network(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 150, color: Colors.grey.shade300),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: scheme.onSurface)),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(description, style: TextStyle(fontSize: 14, height: 1.5, color: scheme.onSurface.withValues(alpha: 0.75))),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeasonsList extends StatelessWidget {
  final List<SeasonInfo> seasons;
  const _SeasonsList({required this.seasons});

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) return const _EmptyState(icon: Icons.wb_sunny_outlined, label: 'No seasons info yet');
    return Column(
      children: seasons.map((s) => _MediaCard(image: s.image, name: s.name, description: s.description)).toList(),
    );
  }
}

class _NamedItemsList extends StatelessWidget {
  final String intro;
  final List<NamedItem> items;
  const _NamedItemsList({required this.intro, required this.items});

  @override
  Widget build(BuildContext context) {
    if (intro.isEmpty && items.isEmpty) {
      return const _EmptyState(icon: Icons.inbox_outlined, label: 'No content yet');
    }
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (intro.isNotEmpty) ...[
          Text(intro, style: TextStyle(fontSize: 15, height: 1.6, color: onSurface)),
          const SizedBox(height: 16),
        ],
        ...items.map((item) => _MediaCard(image: item.image, name: item.name, description: item.description)),
      ],
    );
  }
}

class _FactsList extends StatelessWidget {
  final List<String> facts;
  const _FactsList({required this.facts});

  @override
  Widget build(BuildContext context) {
    if (facts.isEmpty) return const _EmptyState(icon: Icons.lightbulb_outline_rounded, label: 'No facts yet');
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: facts
          .map((f) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(f, style: TextStyle(fontSize: 14, height: 1.4, color: onSurface))),
          ],
        ),
      ))
          .toList(),
    );
  }
}

class _ToursTab extends StatelessWidget {
  final String destinationId;
  const _ToursTab({required this.destinationId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TripModel>>(
      future: TripService.getTripsByDestination(destinationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final trips = snapshot.data ?? [];
        return _SectionScaffold(
          icon: Icons.card_travel_rounded,
          title: 'Tours in this Destination',
          child: trips.isEmpty
              ? const _EmptyState(icon: Icons.card_travel_rounded, label: 'No tours for this destination yet')
              : Column(
            children: trips.map((t) => _TourCard(trip: t)).toList(),
          ),
        );
      },
    );
  }
}

class _TourCard extends StatelessWidget {
  final TripModel trip;
  const _TourCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasDiscount = trip.originalPrice != null && trip.originalPrice! > trip.price;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 5)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.to(() => TripDetailScreen(tripId: trip.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                trip.coverImage.isNotEmpty
                    ? Image.network(
                  trip.coverImage,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  cacheWidth: (400 * MediaQuery.of(context).devicePixelRatio).round(),
                  errorBuilder: (_, __, ___) => Container(height: 150, color: Colors.grey.shade300),
                )
                    : Container(height: 150, color: Colors.grey.shade300),
                if (trip.duration > 0)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule_rounded, size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text('${trip.duration} Days', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                if (trip.rating > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                          const SizedBox(width: 3),
                          Text(trip.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: scheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 14, color: scheme.onSurface.withValues(alpha: 0.5)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          trip.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: scheme.onSurface.withValues(alpha: 0.65)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          'PKR ${trip.originalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: scheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        'PKR ${trip.price.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('View', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.white),
                          ],
                        ),
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
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  const _CircleIconButton({required this.icon, required this.onTap, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}

class _WeatherTab extends StatelessWidget {
  final DestinationModel dest;
  const _WeatherTab({required this.dest});

  @override
  Widget build(BuildContext context) {
    final hasData = dest.coldestMonth.isNotEmpty || dest.hottestMonth.isNotEmpty;
    return _SectionScaffold(
      icon: Icons.thermostat_rounded,
      title: 'Weather',
      child: !hasData
          ? const _EmptyState(icon: Icons.thermostat_rounded, label: 'No weather info yet')
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (dest.coldestMonth.isNotEmpty)
                Expanded(
                  child: _TempCard(
                    icon: Icons.ac_unit_rounded,
                    color: Colors.blueAccent,
                    month: dest.coldestMonth,
                    temp: dest.coldestTemp,
                    label: 'Coldest Month',
                  ),
                ),
              if (dest.coldestMonth.isNotEmpty && dest.hottestMonth.isNotEmpty)
                const SizedBox(width: 12),
              if (dest.hottestMonth.isNotEmpty)
                Expanded(
                  child: _TempCard(
                    icon: Icons.wb_sunny_rounded,
                    color: Colors.orangeAccent,
                    month: dest.hottestMonth,
                    temp: dest.hottestTemp,
                    label: 'Hottest Month',
                  ),
                ),
            ],
          ),
          if (dest.weatherSummary.isNotEmpty) ...[
            const SizedBox(height: 16),
            _BodyText(dest.weatherSummary),
          ],
        ],
      ),
    );
  }
}

class _TempCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String month;
  final String temp;
  final String label;
  const _TempCard({
    required this.icon,
    required this.color,
    required this.month,
    required this.temp,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 2),
          Text(month, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.onSurface)),
          if (temp.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(temp, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ],
      ),
    );
  }
}

class _LazyTab extends StatefulWidget {
  final TabController controller;
  final int index;
  final WidgetBuilder builder;
  const _LazyTab({required this.controller, required this.index, required this.builder});

  @override
  State<_LazyTab> createState() => _LazyTabState();
}

class _LazyTabState extends State<_LazyTab> {
  bool _built = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller.index == widget.index) _built = true;
    widget.controller.addListener(_onTabChange);
  }

  void _onTabChange() {
    if (!_built && widget.controller.index == widget.index) {
      setState(() => _built = true);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _built ? widget.builder(context) : const SizedBox.shrink();
  }
}