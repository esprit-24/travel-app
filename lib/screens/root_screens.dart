// Fichier: lib/screens/root_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart'; // L'écran Accueil que vous avez déjà
import 'profile_screen.dart'; // L'écran Profil à créer

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedNavIndex = 0; // Onglet de navigation sélectionné

  // 1. Définir les Widgets (pages) pour chaque onglet
  final List<Widget> _pages = const [
    HomeScreen(), // Index 0: Accueil (Votre écran existant)
    Center(child: Text('Recherche (Bientôt)')), // Index 1: Recherche
    Center(child: Text('Voyages (Bientôt)')), // Index 2: Voyages
    ProfileScreen(), // Index 3: Profil (La page que nous allons créer)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Afficher uniquement la page sélectionnée dans le corps
      body: _pages[_selectedNavIndex],

      // 3. Barre de Navigation Inférieure (copiée de votre HomeScreen)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: _onItemTapped, // Utiliser la méthode qui change l'index
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
      ),
    );
  }
}