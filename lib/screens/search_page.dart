import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/destination_model.dart';
import '../providers/destination_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/destination_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String selectedFilter = 'Tout';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Destination> _applyFilters(List<Destination> data) {
    var results = [...data];

    // 🔹 Filtrer par type
    if (selectedFilter == 'Hôtels') {
      results = results.where((d) => d.type == 'hotel').toList();
    } else if (selectedFilter == 'Restaurants') {
      results = results.where((d) => d.type == 'restaurant').toList();
    }

    // 🔹 Filtrer par recherche texte
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      results = results.where((d) {
        return d.name.toLowerCase().contains(q) ||
            d.country.toLowerCase().contains(q);
      }).toList();
    }

    return results;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destinationsAsync = ref.watch(destinationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      // ░░░ AppBar ░░░
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Recherche',
          style: TextStyle(
            color: Color(0xFF1A3A52),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      // ░░░ BODY ░░░
      body: destinationsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text("Erreur : $err")),
        data: (destinations) {
          final filtered = _applyFilters(destinations);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔎 Recherche
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) =>
                      setState(() => searchQuery = v),
                  decoration: InputDecoration(
                    hintText:
                    'Rechercher un hôtel ou un restaurant...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          searchQuery = '';
                        });
                      },
                    )
                        : const Icon(Icons.mic_none),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // 🎯 Filtres
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: FilterChipWidget(
                        label: 'Tout',
                        isSelected: selectedFilter == 'Tout',
                        onTap: () =>
                            setState(() => selectedFilter = 'Tout'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterChipWidget(
                        label: 'Hôtels',
                        isSelected:
                        selectedFilter == 'Hôtels',
                        onTap: () =>
                            setState(() => selectedFilter = 'Hôtels'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterChipWidget(
                        label: 'Restaurants',
                        isSelected:
                        selectedFilter == 'Restaurants',
                        onTap: () => setState(
                                () => selectedFilter = 'Restaurants'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Résultats
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Résultats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${filtered.length} options',
                      style:
                      TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Liste
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 12),
                      child: DestinationCard(
                        destination: filtered[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar:
      const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun résultat trouvé',
            style:
            TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
