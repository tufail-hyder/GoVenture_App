import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../services/destination_service.dart';
import '../../tripdetails/models/trip_model.dart';
import '../../../services/trip_service.dart';

class DestinationDetailScreen extends StatefulWidget {
  final String destinationId;
  const DestinationDetailScreen({super.key, required this.destinationId});

  @override
  State<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    'Overview', 'Tours', 'Culture & History', 'Seasons',
    'Food & Cuisines', 'Arts & Crafts', 'Demographics',
    'Attractions', 'Interesting Facts',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DestinationModel?>(
        future: DestinationService.getDestinationById(widget.destinationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final dest = snapshot.data;
          if (dest == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Destination not found')),
            );
          }

          return NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(dest.title),
                  background: dest.coverImage.isNotEmpty
                      ? Image.network(dest.coverImage, fit: BoxFit.cover)
                      : Container(color: Colors.grey.shade400),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: _tabs.map((t) => Tab(text: t)).toList(),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _SectionText(text: dest.overview),
                _ToursTab(destinationId: dest.id),
                _SectionText(text: dest.cultureHistory),
                _SeasonsTab(seasons: dest.seasons),
                _NamedItemsTab(intro: dest.foodIntro, items: dest.foodItems),
                _NamedItemsTab(intro: dest.craftsIntro, items: dest.craftItems),
                _SectionText(text: dest.demographics),
                _NamedItemsTab(intro: '', items: dest.attractions),
                _FactsTab(facts: dest.interestingFacts),
              ],
            ),
          );
        },
      ),
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
    return Container(color: Theme.of(context).scaffoldBackgroundColor, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

class _SectionText extends StatelessWidget {
  final String text;
  const _SectionText({required this.text});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const Center(child: Text('No content yet'));
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }
}

class _SeasonsTab extends StatelessWidget {
  final List<SeasonInfo> seasons;
  const _SeasonsTab({required this.seasons});

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) return const Center(child: Text('No seasons info yet'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: seasons.length,
      itemBuilder: (_, i) {
        final s = seasons[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (s.image.isNotEmpty) Image.network(s.image, height: 150, width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(s.description),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NamedItemsTab extends StatelessWidget {
  final String intro;
  final List<NamedItem> items;
  const _NamedItemsTab({required this.intro, required this.items});

  @override
  Widget build(BuildContext context) {
    if (intro.isEmpty && items.isEmpty) return const Center(child: Text('No content yet'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (intro.isNotEmpty) ...[
          Text(intro, style: const TextStyle(fontSize: 15, height: 1.5)),
          const SizedBox(height: 16),
        ],
        ...items.map((item) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.image.isNotEmpty) Image.network(item.image, height: 150, width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(item.description),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}

class _FactsTab extends StatelessWidget {
  final List<String> facts;
  const _FactsTab({required this.facts});

  @override
  Widget build(BuildContext context) {
    if (facts.isEmpty) return const Center(child: Text('No facts yet'));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: facts.length,
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.check_circle_outline, size: 20),
        title: Text(facts[i]),
        dense: true,
      ),
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
        if (trips.isEmpty) return const Center(child: Text('No tours for this destination yet'));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: trips.length,
          itemBuilder: (_, i) => ListTile(
            leading: const Icon(Icons.card_travel_rounded),
            title: Text(trips[i].title),
            subtitle: Text(trips[i].location),
          ),
        );
      },
    );
  }
}