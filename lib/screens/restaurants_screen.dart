import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/destination_data.dart';
import '../models/destination_model.dart';
import '../widgets/destination_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/bottom_nav_bar.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  String selectedFilter = "Tout";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Liste globale des restaurants récupérée via les données
  List<Destination> get allRestaurants =>
      DestinationsData.destinations.where((d) => d.type == 'restaurant').toList();

  // 🔹 Application des filtres + recherche
  List<Destination> get filteredRestaurants {
    List<Destination> data = [...allRestaurants];

    // Filtre par type de cuisine
    if (selectedFilter != "Tout") {
      data = data.where((r) =>
      r.name.toLowerCase() == selectedFilter.toLowerCase()).toList();
    }

    // Filtre par recherche
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      data = data.where((r) =>
      r.name.toLowerCase().contains(q) ||
          r.country.toLowerCase().contains(q)).toList();
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // -------------------------------------------------------------
      // 🔹 APPBAR
      // -------------------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          "Restaurants",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A52),
          ),
        ),
      ),

      // -------------------------------------------------------------
      // 🔹 CONTENU PRINCIPAL
      // -------------------------------------------------------------
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------------------------------------
            // 🔍 Barre de recherche
            // ---------------------------------------------------------
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => searchQuery = v),
                decoration: InputDecoration(
                  hintText: "Rechercher un restaurant…",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        searchQuery = "";
                        _searchController.clear();
                      });
                    },
                  )
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ---------------------------------------------------------
            // 🔸 Filtres (Tout, Asiatique, Local,…)
            // ---------------------------------------------------------
            Row(
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
                    label: 'Asiatique',
                    isSelected: selectedFilter == 'Asiatique',
                    onTap: () => setState(() => selectedFilter = 'Asiatique'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Local',
                    isSelected: selectedFilter == 'Local',
                    onTap: () => setState(() => selectedFilter = 'Local'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // 🔸 Titre + nombre de résultats
            // ---------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Populaires",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A52),
                  ),
                ),
                Text(
                  "${filteredRestaurants.length} restaurants",
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ---------------------------------------------------------
            // 🔸 Liste des restaurants (DestinationCard)
            // ---------------------------------------------------------
            Expanded(
              child: filteredRestaurants.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                itemCount: filteredRestaurants.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: DestinationCard(
                      destination: filteredRestaurants[i],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // -------------------------------------------------------------
      // 🔹 BOTTOM NAVIGATION
      // -------------------------------------------------------------
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  // -------------------------------------------------------------
  // 🔸 Widget si aucun résultat
  // -------------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Aucun restaurant trouvé",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
