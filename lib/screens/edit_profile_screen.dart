import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 APPBAR
      appBar: const _EditProfileAppBar(),

      // ─────────────────────────────────────
      // BODY
      // ─────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: const [
            SizedBox(height: 10),

            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
              ),
            ),

            SizedBox(height: 10),

            // Champs profil (widget commun)
            AppTextField(
              label: 'Nom',
              hintText: 'Dupont',
              initialValue: 'Dupont',
            ),
            AppTextField(
              label: 'Prénom',
              hintText: 'Alexandre',
              initialValue: 'Alexandre',
            ),
            AppTextField(
              label: 'Email',
              hintText: 'alex.dupont@example.com',
              initialValue: 'alex.dupont@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            AppTextField(
              label: 'Numéro de téléphone',
              hintText: '+33 6 12 34 56 78',
              initialValue: '+33 6 12 34 56 78',
              keyboardType: TextInputType.phone,
            ),
            AppTextField(
              label: 'Mot de passe',
              hintText: '••••••••',
              initialValue: '********',
              obscureText: true,
            ),

            SizedBox(height: 10),

            // 🟩 BOUTON ENREGISTRER
            _SaveProfileButton(),

            SizedBox(height: 10),

            // Bouton ANNULER
            _CancelButton(),
          ],
        ),
      ),
    );
  }
}

/// ============================
/// Bouton Enregistrer
/// ============================
class _SaveProfileButton extends StatelessWidget {
  const _SaveProfileButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// ============================
/// Bouton Annuler
/// ============================
class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/profil'),
      child: Text(
        "Annuler",
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
      ),
    );
  }
}

/// ============================
/// AppBar Modifier Profil
/// ============================
class _EditProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _EditProfileAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Color(0xFF1A3A52),
        ),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
