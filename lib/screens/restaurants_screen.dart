import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/destination_model.dart';
import '../providers/destination_provider.dart';
import '../widgets/destination_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/bottom_nav_bar.dart';

class RestaurantsPage extends ConsumerStatefulWidget {
  const RestaurantsPage({super.key});

  @override
  ConsumerState<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends ConsumerState<RestaurantsPage> {
  String selectedFilter = "Tout";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  List<Destination> _applyFilters(List<Destination> restaurants) {
    var data = [...restaurants];

    // 🔍 Recherche texte
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      data = data.where((r) {
        return r.name.toLowerCase().contains(q) ||
            r.country.toLowerCase().contains(q);
      }).toList();
    }

    // ⚠️ Les filtres Asiatique / Local sont VISUELS pour l’instant
    // (ils seront branchés plus tard sur un champ "category" ou "cuisine")

    return data;
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
      // 🔹 CONTENU
      // -------------------------------------------------------------
      body: destinationsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text("Erreur : $err")),
        data: (destinations) {
          // 🔥 UNIQUEMENT LES RESTAURANTS
          final restaurants =
          destinations.where((d) => d.type == 'restaurant').toList();

          final filteredRestaurants = _applyFilters(restaurants);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 Recherche
                TextField(
                  controller: _searchController,
                  onChanged: (v) =>
                      setState(() => searchQuery = v),
                  decoration: InputDecoration(
                    hintText: "Rechercher un restaurant…",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchQuery = "";
                          _searchController.clear();
                        });
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 🔸 Filtres (UI uniquement pour l’instant)
                Row(
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
                        label: 'Asiatique',
                        isSelected:
                        selectedFilter == 'Asiatique',
                        onTap: () => setState(
                                () => selectedFilter = 'Asiatique'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterChipWidget(
                        label: 'Local',
                        isSelected: selectedFilter == 'Local',
                        onTap: () =>
                            setState(() => selectedFilter = 'Local'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔸 Titre + compteur
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
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
                      style:
                      TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔸 Liste
                Expanded(
                  child: filteredRestaurants.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                    itemCount:
                    filteredRestaurants.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding:
                        const EdgeInsets.only(bottom: 14),
                        child: DestinationCard(
                          destination:
                          filteredRestaurants[i],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar:
      const BottomNavBar(currentIndex: 1),
    );
  }

  // -------------------------------------------------------------
  // 🔸 Empty state
  // -------------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Aucun restaurant trouvé",
            style:
            TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
