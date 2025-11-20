// Fichier: lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; // ⬅️ L'importation de la page d'édition

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A3A52),
        elevation: 0,
        // Pas besoin de flèche de retour car c'est une page d'onglet racine
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            //  (Illustration de la page)

            // Section Infos Utilisateur
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2'),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alexandre Dupont',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'alex.dupont@example.com',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ✏️ Bouton MODIFIER PROFIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8F5E9), // Vert clair
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.edit, color: const Color(0xFF4CAF50)),
                label: const Text(
                  'Modifier profil',
                  style: TextStyle(color: Color(0xFF4CAF50), fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  // ➡️ NAVIGUER VERS LA PAGE D'ÉDITION
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ),

            // 🚪 Bouton SE DÉCONNECTER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50, // Rouge clair
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.logout, color: Colors.red.shade600),
                label: Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.red.shade600, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  // Logique de déconnexion...
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}