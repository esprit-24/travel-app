import 'package:flutter/material.dart';
import '../widgets/custom_filter_chip.dart';
import '../widgets/hotel_destination_card.dart';
import '../widgets/custom_bottom_nav.dart';
import '../models/destination_model.dart';
import '../data/destinations_data.dart';

class TravelSearchPage extends StatefulWidget {
  const TravelSearchPage({Key? key}) : super(key: key);

  @override
  State<TravelSearchPage> createState() => _TravelSearchPageState();
}

class _TravelSearchPageState extends State<TravelSearchPage> {
  String selectedFilter = 'Tout';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

// Fonction pour obtenir les résultats filtrés

  List<Destination> _getFilteredResults() {
    List<Destination> results = [];

    // Filtrer par catégorie (Tout, Hôtels, Restaurants)
    if (selectedFilter == 'Tout') {
      results = [...DestinationsData.hotels, ...DestinationsData.restaurants];
      // Mélanger aléatoirement pour "Tout"
      results.shuffle();
    } else if (selectedFilter == 'Hôtels') {
      results = DestinationsData.hotels;
    } else if (selectedFilter == 'Restaurants') {
      results = DestinationsData.restaurants;
    }

    // Filtrer par recherche
    if (searchQuery.isNotEmpty) {
      results = results.where((destination) {
        final nameLower = destination.name.toLowerCase();
        final countryLower = destination.country.toLowerCase();
        final queryLower = searchQuery.toLowerCase();
        return nameLower.contains(queryLower) || countryLower.contains(queryLower);
      }).toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = _getFilteredResults();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () {},
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher un vol, hôtel, destination...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
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

          // Filtres
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomFilterChip(
                    label: 'Tout',
                    isSelected: selectedFilter == 'Tout',
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Tout';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CustomFilterChip(
                    label: 'Hôtels',
                    isSelected: selectedFilter == 'Hôtels',
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Hôtels';
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  CustomFilterChip(
                    label: 'Restaurants',
                    isSelected: selectedFilter == 'Restaurants',
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Restaurants';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // En-tête des résultats
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
                  '${filteredResults.length} options',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Liste des destinations
          Expanded(
            child: filteredResults.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
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
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                final item = filteredResults[index];
                return DestinationCard(destination: item);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}