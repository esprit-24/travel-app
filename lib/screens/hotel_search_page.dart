import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/widgets/bottom_nav_bar.dart';

import '../data/destination_data.dart';
import '../models/destination_model.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/destination_card.dart';
import '../widgets/search_bar_widget.dart';

import '../services/hotel_search_service.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  // ─────────────────────────────────────
  // ÉTATS
  // ─────────────────────────────────────
  String selectedFilter = 'Étoiles';
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
    _refreshHotels();
  }

  // ─────────────────────────────────────
  // ASYNC (SIMULÉ)
  // ─────────────────────────────────────
  Future<void> _refreshHotels() async {
    setState(() => _isLoading = true);

    // ⏳ Simulation appel réseau / base
    await Future.delayed(const Duration(milliseconds: 400));

    final hotels = HotelSearchService.filterHotels(
      destinations: DestinationsData.destinations,
      selectedFilter: selectedFilter,
      searchQuery: searchQuery,
    );

    setState(() {
      _results = hotels;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Hôtels',
          style: TextStyle(
            color: Color(0xFF1A3A52),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      // ───────────── BODY ─────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔎 SearchBar unifiée (design Home)
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'Rechercher un hôtel...',
              onChanged: (value) {
                searchQuery = value;
                _refreshHotels();
              },
              onClear: () {
                _searchController.clear();
                searchQuery = '';
                _refreshHotels();
              },
            ),
          ),

          // 🎯 Filtres
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: FilterChipWidget(
                    label: 'Étoiles',
                    isSelected: selectedFilter == 'Étoiles',
                    onTap: () {
                      selectedFilter = 'Étoiles';
                      _refreshHotels();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Prix',
                    isSelected: selectedFilter == 'Prix',
                    onTap: () {
                      selectedFilter = 'Prix';
                      _refreshHotels();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Popularité',
                    isSelected: selectedFilter == 'Popularité',
                    onTap: () {
                      selectedFilter = 'Popularité';
                      _refreshHotels();
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔸 Titre + compteur
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
                  '${_results.length} hôtels',
                  style: TextStyle(color: Colors.grey[500]),
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
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DestinationCard(
                    destination: _results[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),

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
            'Aucun hôtel trouvé',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
