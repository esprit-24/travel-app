import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/trip_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../models/trip_model.dart';
import '../providers/trips_provider.dart';

class TripsPage extends ConsumerStatefulWidget {
  const TripsPage({super.key});

  @override
  ConsumerState<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends ConsumerState<TripsPage> {
  String selectedFilter = 'Disponibles';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // 🔎 Filtrage local (recherche texte)
  List<Trip> _filterTrips(List<Trip> trips) {
    if (searchQuery.isEmpty) return trips;

    final q = searchQuery.toLowerCase();
    return trips.where((trip) {
      return trip.title.toLowerCase().contains(q) ||
          trip.country.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(tripsProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      // --------------------------------------------------
      // 🔹 APPBAR
      // --------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        centerTitle: true,
        title: const Text(
          "Voyages",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: const [
          Icon(Icons.tune, color: Colors.black),
          SizedBox(width: 15),
        ],
      ),

      // --------------------------------------------------
      // 🔹 BODY
      // --------------------------------------------------
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔎 Recherche
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => searchQuery = value);
                      },
                      decoration: const InputDecoration(
                        hintText: "Rechercher un voyage...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔥 Filtre simple
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 150,
                child: FilterChipWidget(
                  label: 'Disponibles',
                  isSelected: selectedFilter == 'Disponibles',
                  onTap: () => setState(() {
                    selectedFilter = 'Disponibles';
                  }),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // --------------------------------------------------
            // 🔹 LISTE DES VOYAGES (API)
            // --------------------------------------------------
            Expanded(
              child: tripsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),

                error: (err, _) => Center(
                  child: Text(
                    "Erreur : $err",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

                data: (List<Trip> trips) {
                  final filteredTrips = _filterTrips(trips);

                  if (filteredTrips.isEmpty) {
                    return Center(
                      child: Text(
                        "Aucun voyage trouvé",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = filteredTrips[index];
                      return TripCard(
                        trip: trip,
                        onTap: () {
                          // Détail voyage plus tard
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
