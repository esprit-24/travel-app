import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/trip_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/search_bar_widget.dart';

import '../models/trip_model.dart';
import '../data/trips_data.dart';
import '../services/trip_search_service.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  // ─────────────────────────────────────
  // ÉTATS
  // ─────────────────────────────────────
  String selectedFilter = 'Disponibles';
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  List<Trip> _results = [];

  // ─────────────────────────────────────
  // INIT
  // ─────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _refreshTrips(); // chargement initial
  }

  // ─────────────────────────────────────
  // LOGIQUE ASYNCHRONE (SIMULÉE)
  // ─────────────────────────────────────
  Future<void> _refreshTrips() async {
    setState(() {
      _isLoading = true;
    });

    // ⏳ Simulation d’un appel réseau / base de données
    await Future.delayed(const Duration(milliseconds: 400));

    final filteredTrips = TripSearchService.filterTrips(
      trips: TripsData.trips,
      searchQuery: searchQuery,
    );

    setState(() {
      _results = filteredTrips;
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
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        title: const Text(
          'Voyages',
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

      // ───────────── BODY ─────────────
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔎 SearchBar réutilisable
            SearchBarWidget(
              controller: _searchController,
              hintText: 'Rechercher un voyage...',
              onChanged: (value) {
                searchQuery = value;
                _refreshTrips();
              },
              onClear: () {
                _searchController.clear();
                searchQuery = '';
                _refreshTrips();
              },
            ),

            const SizedBox(height: 15),

            // 🔥 Filtre "Disponibles"
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 150,
                child: FilterChipWidget(
                  label: 'Disponibles',
                  isSelected: selectedFilter == 'Disponibles',
                  onTap: () {
                    selectedFilter = 'Disponibles';
                    _refreshTrips();
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ───────────── CONTENU ─────────────
            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _results.isEmpty
                  ? Center(
                child: Text(
                  'Aucun voyage trouvé',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final Trip trip = _results[index];
                  return TripCard(
                    trip: trip,
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ───────────── BOTTOM NAV ─────────────
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
