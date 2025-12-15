import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 APPBAR
      appBar: const _ProfileAppBar(),

      // ──────────────── BODY ────────────────
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),

            // 🔹 INFOS UTILISATEUR (extrait)
            const _UserInfoSection(),

            const SizedBox(height: 40),

            // ──────────────── Bouton MODIFIER PROFIL ────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4F0EC),
                  minimumSize: const Size(double.infinity, 52),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit, color: Color(0xFF00897B)),
                label: const Text(
                  'Modifier profil',
                  style: TextStyle(
                    color: Color(0xFF00897B),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  context.go('/profil/edit');
                },
              ),
            ),

            // ──────────────── Bouton DECONNEXION ────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  minimumSize: const Size(double.infinity, 52),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Color(0xFFD32F2F)),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  // 👉 Déconnexion via Riverpod
                  ref.read(authProvider.notifier).state = false;
                  // Redirection gérée automatiquement par le router
                },
              ),
            ),
          ],
        ),
      ),

      // ──────────────── BOTTOM NAV ────────────────
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}

/// ============================
/// AppBar Profil
/// ============================
class _ProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ProfileAppBar();

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
        onPressed: () => context.go('/home'),
      ),

      title: const Text(
        'Profil',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A3A52),
        ),
      ),

      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.more_vert,
            color: Color(0xFF1A3A52),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// ============================
/// Section Infos Utilisateur
/// ============================
class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Alexandre Dupont',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'alex.dupont@example.com',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
