import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/destination_model.dart';
import '../services/destination_service.dart';
import 'destination_detail_screen.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';

enum _SortOption { none, azAsc, azDesc}

class AllDestinationsScreen extends StatefulWidget {
  const AllDestinationsScreen({super.key});

  @override
  State<AllDestinationsScreen> createState() => _AllDestinationsScreenState();
}

class _AllDestinationsScreenState extends State<AllDestinationsScreen> {
  static const _regions = [
    ('All', Icons.public_rounded),
    ('Gilgit Baltistan', Icons.terrain_outlined),
    ('Azad Jammu & Kashmir', Icons.filter_hdr_outlined),
    ('Islamabad Capital Territory', Icons.location_city_outlined),
    ('Punjab', Icons.account_balance_outlined),
    ('Sindh', Icons.waves_outlined),
    ('Khyber Pakhtunkhwa', Icons.landscape_outlined),
    ('Balochistan', Icons.diamond_outlined),
  ];

  String _selectedRegion = 'All';
  String _searchQuery = '';
  _SortOption _sortOption = _SortOption.none;
  final TextEditingController _searchController = TextEditingController();
  late final Future<List<DestinationModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = DestinationService.getAllDestinations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DestinationModel> _applySort(List<DestinationModel> list) {
    final sorted = [...list];
    switch (_sortOption) {
      case _SortOption.azAsc:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case _SortOption.azDesc:
        sorted.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case _SortOption.none:
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Destinations')),
        body: FutureBuilder<List<DestinationModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final all = snapshot.data ?? [];
            if (all.isEmpty) {
              return const Center(child: Text('No destinations found'));
            }

            final query = _searchQuery.trim().toLowerCase();
            var destinations = all.where((d) {
              final matchesRegion = _selectedRegion == 'All' || d.region == _selectedRegion;
              final matchesSearch = query.isEmpty ||
                  d.title.toLowerCase().contains(query) ||
                  d.location.toLowerCase().contains(query);
              return matchesRegion && matchesSearch;
            }).toList();
            destinations = _applySort(destinations);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Search bar with sort icon =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm, AppSizes.md, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: scheme.outline.withValues(alpha: 0.15)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: TextStyle(color: scheme.onSurface, fontSize: 14.5),
                      decoration: InputDecoration(
                        hintText: 'Search destinations...',
                        hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.4), fontSize: 14.5),
                        prefixIcon: Icon(Icons.search_rounded, color: scheme.onSurface.withValues(alpha: 0.5), size: 22),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.close_rounded, size: 18, color: scheme.onSurface.withValues(alpha: 0.5)),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              ),
                            PopupMenuButton<_SortOption>(
                              icon: Icon(
                                Icons.sort_rounded,
                                size: 22,
                                color: _sortOption == _SortOption.none
                                    ? scheme.onSurface.withValues(alpha: 0.5)
                                    : AppColors.primary,
                              ),
                              tooltip: 'Sort',
                              onSelected: (option) => setState(() => _sortOption = option),
                              itemBuilder: (context) => [
                                _sortMenuItem(_SortOption.azAsc, 'Sort A-Z', Icons.arrow_downward_rounded),
                                _sortMenuItem(_SortOption.azDesc, 'Sort Z-A', Icons.arrow_upward_rounded),
                              ],
                            ),
                          ],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                      ),
                    ),
                  ),
                ),

                // ===== Browse by Regions =====
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.sm),
                  child: Text(
                    'Browse by Regions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: scheme.onSurface),
                  ),
                ),
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                    scrollDirection: Axis.horizontal,
                    itemCount: _regions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final region = _regions[i];
                      final isSelected = _selectedRegion == region.$1;
                      return _RegionCard(
                        label: region.$1,
                        icon: region.$2,
                        isSelected: isSelected,
                        onTap: () => setState(() => _selectedRegion = region.$1),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSizes.md),

                // ===== Dynamic title above the grid =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  child: Row(
                    children: [
                      Text(
                        _selectedRegion == 'All' ? 'All Destinations' : _selectedRegion,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: scheme.onSurface),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${destinations.length}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSizes.xs),

                // ===== Destinations grid =====
                Expanded(
                  child: destinations.isEmpty
                      ? Center(
                    child: Text(
                      query.isNotEmpty ? 'No destinations match "$_searchQuery"' : 'No destinations in this region yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6)),
                    ),
                  )
                      : GridView.builder(
                    padding: const EdgeInsets.all(AppSizes.md),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSizes.sm,
                      crossAxisSpacing: AppSizes.sm,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: destinations.length,
                    itemBuilder: (_, i) {
                      final dest = destinations[i];
                      return GestureDetector(
                        onTap: () => Get.to(() => DestinationDetailScreen(destinationId: dest.id)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                          child: Stack(
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
                                    stops: [0.4, 1.0],
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
                                      dest.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    if (dest.location.isNotEmpty)
                                      Text(
                                        dest.location,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  PopupMenuItem<_SortOption> _sortMenuItem(_SortOption option, String label, IconData icon) {
    final isSelected = _sortOption == option;
    return PopupMenuItem(
      value: option,
      child: Row(
        children: [
          Icon(icon, size: 18, color: isSelected ? AppColors.primary : Colors.grey),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              color: isSelected ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _RegionCard({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : scheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: isSelected ? Colors.white : AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}