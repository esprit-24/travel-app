// Fichier: lib/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier profil'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A3A52),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //  (Illustration de la page)

            // Avatar (pour compléter le design)
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2'),
            ),
            const SizedBox(height: 30),

            // ➡️ CHAMPS DE TEXTE (Exemple simple)
            _buildTextField('Nom', 'Dupont'),
            _buildTextField('Prénom', 'Alexandre'),
            _buildTextField('Email', 'alex.dupont@example.com'),
            _buildTextField('Numéro de téléphone', '+33 6 12 34 56 78'),
            _buildTextField('Mot de passe', '********', obscureText: true),

            const SizedBox(height: 40),

            // 💾 Bouton ENREGISTRER
            ElevatedButton(
              onPressed: () {
                // Ici, vous enregistrez les données...

                // ➡️ Revenir à la page précédente
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8F5E9), // Vert clair
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Enregistrer les modifications',
                style: TextStyle(color: Color(0xFF4CAF50), fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 10),

            // ❌ Bouton ANNULER
            TextButton(
              onPressed: () {
                // ➡️ Revenir à la page précédente sans enregistrer
                Navigator.pop(context);
              },
              child: const Text('Annuler', style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper pour simplifier la création des champs
  Widget _buildTextField(String label, String initialValue, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          TextFormField(
            initialValue: initialValue,
            obscureText: obscureText,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              border: UnderlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}