import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/destination_card.dart';
import '../widgets/search_bar_widget.dart';

import '../data/destination_data.dart';
import '../models/destination_model.dart';
import '../services/destination_search_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ─────────────────────────────────────
  // ÉTATS
  // ─────────────────────────────────────
  String selectedFilter = 'Tout';
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  List<Destination> _results = [];

  // ─────────────────────────────────────
  // INIT
  // ─────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _refreshResults(); // chargement initial
  }

  // ─────────────────────────────────────
  // LOGIQUE ASYNCHRONE (SIMULÉE)
  // ─────────────────────────────────────
  Future<void> _refreshResults() async {
    setState(() {
      _isLoading = true;
    });

    // ⏳ Simulation d’un appel réseau / base de données
    await Future.delayed(const Duration(milliseconds: 400));

    final filtered = DestinationSearchService.filterDestinations(
      destinations: DestinationsData.destinations,
      selectedFilter: selectedFilter,
      searchQuery: searchQuery,
    );

    setState(() {
      _results = filtered;
      _isLoading = false;
    });
  }

  // ─────────────────────────────────────
  // DISPOSE
  // ─────────────────────────────────────
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────
  // UI
  // ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ───────────── APPBAR ─────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Recherche',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A52),
          ),
        ),
      ),

      // ───────────── BODY ─────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔎 SEARCH BAR (widget extrait)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Rechercher un vol, hôtel, restaurant...',
              onChanged: (value) {
                searchQuery = value;
                _refreshResults();
              },
              onClear: () {
                _searchController.clear();
                searchQuery = '';
                _refreshResults();
              },
            ),
          ),

          // 🎯 FILTRES
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: FilterChipWidget(
                    label: 'Tout',
                    isSelected: selectedFilter == 'Tout',
                    onTap: () {
                      selectedFilter = 'Tout';
                      _refreshResults();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Hôtels',
                    isSelected: selectedFilter == 'Hôtels',
                    onTap: () {
                      selectedFilter = 'Hôtels';
                      _refreshResults();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Restaurants',
                    isSelected: selectedFilter == 'Restaurants',
                    onTap: () {
                      selectedFilter = 'Restaurants';
                      _refreshResults();
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ───────────── HEADER RÉSULTATS ─────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Résultats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A52),
                  ),
                ),
                Text(
                  '${_results.length} options',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ───────────── CONTENU ─────────────
          Expanded(
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00897B),
              ),
            )
                : _results.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DestinationCard(
                    destination: _results[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ───────────── BOTTOM NAV ─────────────
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  // ─────────────────────────────────────
  // EMPTY STATE
  // ─────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun résultat trouvé',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
