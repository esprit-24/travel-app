import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:travel_app/data/destination_data.dart';
import 'package:travel_app/models/destination_model.dart';
import 'package:travel_app/widgets/bottom_nav_bar.dart';
import 'package:travel_app/widgets/search_bar_widget.dart';
import '../widgets/destination_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedFilter = 0;

  late final List<Destination> _sortedByRating;
  late final List<Destination> _topTwo;

  // Controller uniquement pour l’affichage
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _sortedByRating = [...DestinationsData.destinations];
    _sortedByRating.sort((a, b) => b.rating.compareTo(a.rating));
    _topTwo = _sortedByRating.take(2).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 APPBAR
      appBar: const _HomeAppBar(),

      // 🔹 BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 🔎 SEARCH BAR (widget commun)
              GestureDetector(
                onTap: () => context.go('/search'),
                child: AbsorbPointer(
                  child: SearchBarWidget(
                    controller: _searchController,
                    hintText: "Rechercher un vol, hôtel, destination...",
                    enabled: false, // identique au comportement précédent
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🔸 FILTRES
              Row(
                children: [
                  Expanded(
                    child: FilterChipWidget(
                      label: 'Tout',
                      isSelected: _selectedFilter == 0,
                      onTap: () => setState(() => _selectedFilter = 0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterChipWidget(
                      label: 'Hôtels',
                      isSelected: _selectedFilter == 2,
                      onTap: () {
                        setState(() => _selectedFilter = 2);
                        context.go('/hotels');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterChipWidget(
                      label: 'Restaurants',
                      isSelected: _selectedFilter == 3,
                      onTap: () {
                        setState(() => _selectedFilter = 3);
                        context.go('/restaurants');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 🔸 DESTINATIONS POPULAIRES
              const Text(
                'Destinations populaires',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A52),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: List.generate(_topTwo.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index == 0 ? 16 : 0),
                      child: DestinationCard(
                        destination: _topTwo[index],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

              // 🔸 MÉTÉO DU JOUR
              const Text(
                'Météo du jour',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A52),
                ),
              ),

              const SizedBox(height: 25),
              const WeatherCard(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      // 🔹 BOTTOM NAV
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}

/// ============================
/// AppBar Home
/// ============================
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,

      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: GestureDetector(
          onTap: () => context.go('/profil'),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF1A3A52),
            ),
          ),
        ),
      ),
      leadingWidth: 70,

      title: const Text(
        'Travel App',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A3A52),
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () => context.go('/notifications'),
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF1A3A52),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
