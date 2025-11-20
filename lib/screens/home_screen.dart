import 'package:flutter/material.dart';
import '../models/destination_model.dart';
import '../widgets/destination_card.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ============================================================
  // 🔹 VARIABLES D'ÉTAT
  // ============================================================
  int _selectedFilter = 0; // Filtre actuellement sélectionné
  int _selectedNavIndex = 0; // Onglet de navigation sélectionné

  // Liste statique de destinations populaires
  final List<Destination> destinations = const [
    Destination(
      image: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
      name: 'Santorin',
      country: 'Grèce',
      price: '\$420',
    ),
    Destination(
      image: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf',
      name: 'Tokyo',
      country: 'Japon',
      price: '\$680',
    ),
  ];

  // ============================================================
  // 🔹 CONSTRUCTION DE L'ÉCRAN PRINCIPAL
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // 🔸 APP BAR (BARRE SUPÉRIEURE)
      // ============================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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
        ],
      ),

      // ============================================================
      // 🔸 CONTENU PRINCIPAL (BODY)
      // ============================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ======================================================
              // 🔹 BARRE DE RECHERCHE
              // ======================================================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Rechercher un vol, hôtel, destination...",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ======================================================
              // 🔹 BOUTONS DE FILTRE
              // ======================================================
              Row(
                children: [
                  FilterChipWidget(
                    label: 'Tout',
                    isSelected: _selectedFilter == 0,
                    onTap: () => setState(() => _selectedFilter = 0),
                  ),
                  const SizedBox(width: 40),
                  FilterChipWidget(
                    label: 'Hôtels',
                    isSelected: _selectedFilter == 2,
                    onTap: () => setState(() => _selectedFilter = 2),
                  ),
                  const SizedBox(width: 40),
                  FilterChipWidget(
                    label: 'Restaurants',
                    isSelected: _selectedFilter == 3,
                    onTap: () => setState(() => _selectedFilter = 3),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // ======================================================
              // 🔹 SECTION : DESTINATIONS POPULAIRES
              // ======================================================
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
                children: [
                  Expanded(child: DestinationCard(destination: destinations[0])),
                  const SizedBox(width: 16),
                  Expanded(child: DestinationCard(destination: destinations[1])),
                ],
              ),

              const SizedBox(height: 30),

              // ======================================================
              // 🔹 SECTION : MÉTÉO DU JOUR
              // ======================================================
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

      // ============================================================
      // 🔸 BARRE DE NAVIGATION INFÉRIEURE
      // ============================================================
     /* bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00897B),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Voyages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),*/
    );
  }
}
