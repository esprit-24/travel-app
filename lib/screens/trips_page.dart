import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/trip_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../models/trip_model.dart';
import '../data/trips_data.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {

  String selectedFilter = 'Disponibles';
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // 🔎 Fonction recherche
  List<Trip> _getFilteredTrips() {
    return TripsData.trips.where((trip) {
      final q = searchQuery.toLowerCase();
      return trip.title.toLowerCase().contains(q) ||
          trip.country.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final trips = _getFilteredTrips();

    return Scaffold(
      backgroundColor: Colors.white,

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

            // 🔥 Chip "Disponibles"
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 150,
                child: FilterChipWidget(
                  label: 'Disponibles',
                  isSelected: selectedFilter == 'Disponibles',
                  onTap: () => setState(() => selectedFilter = 'Disponibles'),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // LISTE DES VOYAGES
            Expanded(
              child: trips.isEmpty
                  ? Center(
                child: Text(
                  "Aucun voyage trouvé",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
                  : ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final Trip t = trips[index];
                  return TripCard(trip: t, onTap: () {});
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
