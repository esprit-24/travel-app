import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/destination_model.dart';
import '../providers/destination_provider.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/destination_card.dart';
import '../widgets/bottom_nav_bar.dart';

class HotelSearchPage extends ConsumerStatefulWidget {
  const HotelSearchPage({super.key});

  @override
  ConsumerState<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends ConsumerState<HotelSearchPage> {
  String selectedFilter = 'Étoiles';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Destination> _applyFilters(List<Destination> hotels) {
    var results = [...hotels];

    // 🔎 Recherche texte
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      results = results.where((h) {
        return h.name.toLowerCase().contains(q) ||
            h.country.toLowerCase().contains(q);
      }).toList();
    }

    // 🔃 Tri
    if (selectedFilter == 'Étoiles') {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (selectedFilter == 'Prix') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedFilter == 'Popularité') {
      results.sort((a, b) => b.reviews.compareTo(a.reviews));
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

      body: destinationsAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, _) =>
            Center(child: Text("Erreur : $err")),
        data: (destinations) {
          // 🔥 UNIQUEMENT LES HÔTELS
          final hotels =
          destinations.where((d) => d.type == 'hotel').toList();

          final filteredHotels = _applyFilters(hotels);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Recherche
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) =>
                      setState(() => searchQuery = v),
                  decoration: InputDecoration(
                    hintText: "Rechercher un hôtel...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchQuery = '';
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
              ),

              // 🎯 Filtres
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: FilterChipWidget(
                        label: 'Étoiles',
                        isSelected:
                        selectedFilter == 'Étoiles',
                        onTap: () => setState(
                                () => selectedFilter = 'Étoiles'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterChipWidget(
                        label: 'Prix',
                        isSelected: selectedFilter == 'Prix',
                        onTap: () =>
                            setState(() => selectedFilter = 'Prix'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilterChipWidget(
                        label: 'Popularité',
                        isSelected:
                        selectedFilter == 'Popularité',
                        onTap: () => setState(() =>
                        selectedFilter = 'Popularité'),
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
                      "Résultats",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${filteredHotels.length} hôtels',
                      style:
                      TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // LISTE
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16),
                  itemCount: filteredHotels.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                      const EdgeInsets.only(bottom: 16),
                      child: DestinationCard(
                        destination: filteredHotels[index],
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
}
