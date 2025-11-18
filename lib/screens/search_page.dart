import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/destination_card.dart';

import '../data/destination_data.dart';
import '../models/destination_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedFilter = 'Tout';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // 🔍 Fonction principale de filtrage
  List<Destination> _getFilteredResults() {
    List<Destination> results = [...DestinationsData.destinations];

    // 🔹 Filtrer selon type : hôtel ou restaurant
    if (selectedFilter == 'Hôtels') {
      results = results.where((d) => d.type == 'hotel').toList();
    } else if (selectedFilter == 'Restaurants') {
      results = results.where((d) => d.type == 'restaurant').toList();
    } else {
      // "Tout" → mélangé
      results.shuffle();
    }

    // 🔹 Filtrer selon texte recherché
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
    final filtered = _getFilteredResults();

    return Scaffold(
      backgroundColor: Colors.white,

      // ░░░ AppBar avec retour ░░░
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔎 Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Rechercher un vol, hôtel, restaurant...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[400]),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        searchQuery = '';
                      });
                    },
                  )
                      : Icon(Icons.mic_none, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // 🎯 Filtres
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FilterChipWidget(
                    label: 'Tout',
                    isSelected: selectedFilter == 'Tout',
                    onTap: () => setState(() => selectedFilter = 'Tout'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Hôtels',
                    isSelected: selectedFilter == 'Hôtels',
                    onTap: () => setState(() => selectedFilter = 'Hôtels'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Restaurants',
                    isSelected: selectedFilter == 'Restaurants',
                    onTap: () => setState(() => selectedFilter = 'Restaurants'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // En-tête "Résultats"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  '${filtered.length} options',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ░░░ Liste ░░░
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: DestinationCard(destination: filtered[index]),
                );
              },
            ),
          ),
        ],
      ),

      // ░░░ Navigation inférieure ░░░
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
