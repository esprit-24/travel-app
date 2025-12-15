import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/destination_data.dart';
import '../models/destination_model.dart';

import '../widgets/destination_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/search_bar_widget.dart';

import '../services/restaurant_search_service.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
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
    _refreshRestaurants();
  }

  // ─────────────────────────────────────
  // ASYNC (SIMULÉ)
  // ─────────────────────────────────────
  Future<void> _refreshRestaurants() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 400));

    final filtered = RestaurantSearchService.filterRestaurants(
      destinations: DestinationsData.destinations,
      selectedFilter: selectedFilter,
      searchQuery: searchQuery,
    );

    setState(() {
      _results = filtered;
      _isLoading = false;
    });
  }

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
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Restaurants',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A52),
          ),
        ),
      ),

      // ───────────── BODY ─────────────
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔎 SearchBar réutilisée
            SearchBarWidget(
              controller: _searchController,
              hintText: 'Rechercher un restaurant…',
              onChanged: (value) {
                searchQuery = value;
                _refreshRestaurants();
              },
              onClear: () {
                _searchController.clear();
                searchQuery = '';
                _refreshRestaurants();
              },
            ),

            const SizedBox(height: 18),

            // 🔸 Filtres
            Row(
              children: [
                Expanded(
                  child: FilterChipWidget(
                    label: 'Tout',
                    isSelected: selectedFilter == 'Tout',
                    onTap: () {
                      selectedFilter = 'Tout';
                      _refreshRestaurants();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Asiatique',
                    isSelected: selectedFilter == 'Asiatique',
                    onTap: () {
                      selectedFilter = 'Asiatique';
                      _refreshRestaurants();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Local',
                    isSelected: selectedFilter == 'Local',
                    onTap: () {
                      selectedFilter = 'Local';
                      _refreshRestaurants();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔸 Titre + compteur
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Populaires',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A52),
                  ),
                ),
                Text(
                  '${_results.length} restaurants',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
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
                itemCount: _results.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: DestinationCard(
                      destination: _results[i],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun restaurant trouvé',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
