import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ─────────────────────────────────────
      // APPBAR AVEC FLECHE RETOUR
      // ─────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/profil'),
        ),
        title: const Text(
          'Modifier profil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A52),
          ),
        ),
      ),

      // ─────────────────────────────────────
      // BODY
      // ─────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
              ),
            ),

            const SizedBox(height: 10),

            // Champs nom / prénom / email / phone / pwd
            _buildTextField("Nom", "Dupont"),
            _buildTextField("Prénom", "Alexandre"),
            _buildTextField("Email", "alex.dupont@example.com"),
            _buildTextField("Numéro de téléphone", "+33 6 12 34 56 78"),
            _buildTextField("Mot de passe", "********", obscureText: true),

            const SizedBox(height: 10),

            // 🟩 BOUTON ENREGISTRER
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.go('/profil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4F0EC),
                  foregroundColor: const Color(0xFF00897B),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Enregistrer les modifications",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Bouton ANNULER
            TextButton(
              onPressed: () => context.go('/profil'),
              child: Text(
                "Annuler",
                style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────
  // TEXTFIELD RÉUTILISABLE (style Register)
  // ─────────────────────────────────────
  Widget _buildTextField(
      String label,
      String initialValue, {
        bool obscureText = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          // TextField
          TextFormField(
            initialValue: initialValue,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF00897B),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
