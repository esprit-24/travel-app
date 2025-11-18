import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/widgets/bottom_nav_bar.dart';

import '../data/destination_data.dart';
import '../models/destination_model.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/destination_card.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  String selectedFilter = 'Étoiles';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Récupère uniquement les hôtels depuis la base globale
  List<Destination> get allHotels =>
      DestinationsData.destinations.where((d) => d.type == 'hotel').toList();

  // 🔹 Application des filtres
  List<Destination> _filterHotels() {
    List<Destination> hotels = [...allHotels];

    // Recherche
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      hotels = hotels.where((h) {
        return h.name.toLowerCase().contains(q) ||
            h.country.toLowerCase().contains(q);
      }).toList();
    }

    // Tri
    if (selectedFilter == 'Étoiles') {
      hotels.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (selectedFilter == 'Prix') {
      hotels.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedFilter == 'Popularité') {
      hotels.sort((a, b) => b.reviews.compareTo(a.reviews));
    }

    return hotels;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hotels = _filterHotels();

    return Scaffold(
      backgroundColor: Colors.white,

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

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => searchQuery = v),
                decoration: InputDecoration(
                  hintText: "Rechercher un hôtel...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                      : null,
                ),
              ),
            ),
          ),

          // 🎯 Filtres avec FilterChipWidget
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: FilterChipWidget(
                    label: 'Étoiles',
                    isSelected: selectedFilter == 'Étoiles',
                    onTap: () => setState(() => selectedFilter = 'Étoiles'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Prix',
                    isSelected: selectedFilter == 'Prix',
                    onTap: () => setState(() => selectedFilter = 'Prix'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilterChipWidget(
                    label: 'Popularité',
                    isSelected: selectedFilter == 'Popularité',
                    onTap: () => setState(() => selectedFilter = 'Popularité'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Titre + nombre de résultats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Résultats",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A52),
                  ),
                ),
                Text(
                  '${hotels.length} hôtels',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // LISTE DES HÔTELS — en utilisant DestinationCard 🔥
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DestinationCard(destination: hotel), // 👈🔥 SIMPLE, PROPRE
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}