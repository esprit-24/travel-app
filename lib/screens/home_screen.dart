import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:travel_app/data/destination_data.dart';
import 'package:travel_app/models/destination_model.dart';
import 'package:travel_app/widgets/bottom_nav_bar.dart';
import '../providers/user_provider.dart';
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

  @override
  void initState() {
    super.initState();

    _sortedByRating = [...DestinationsData.destinations];
    _sortedByRating.sort((a, b) => b.rating.compareTo(a.rating));
    _topTwo = _sortedByRating.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ----------------------------------------------------------------------
      // 🔹 APPBAR
      // ----------------------------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        // ⬅️ PHOTO DU USER À GAUCHE
        leading: Consumer(
          builder: (context, ref, _) {
            final userAsync = ref.watch(userProvider);

            return userAsync.when(
              loading: () => Padding(
                padding: const EdgeInsets.only(left: 15),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),

              error: (err, _) => const Icon(Icons.error, color: Colors.red),

              data: (user) {
                // Anti-cache si photoUrl existe
                final photoUrl = (user != null && user.photoUrl != null)
                    ? "${user.photoUrl}?v=${DateTime.now().millisecondsSinceEpoch}"
                    : "https://images.unsplash.com/photo-1544005313-94ddf0286df2";

                return GestureDetector(
                  onTap: () => context.go('/profil'),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey.shade300,
                      child: ClipOval(
                        child: Image.network(
                          photoUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 22,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),

        title: const Text(
          'Travel App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A52),
          ),
        ),

        // ➡️ BOUTON NOTIFICATIONS À DROITE
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
      ),

      // ----------------------------------------------------------------------
      // 🔹 BODY
      // ----------------------------------------------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 🔎 BARRE DE RECHERCHE
              GestureDetector(
                onTap: () => context.go('/search'),
                child: AbsorbPointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Rechercher un vol, hôtel, destination...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon:
                        Icon(Icons.search, color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: DestinationCard(destination: _topTwo[index]),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 30),

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

      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
