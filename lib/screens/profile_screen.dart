import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../providers/user_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
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
      ),

      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF00897B)),
        ),
        error: (err, _) => Center(
          child: Text(
            "Erreur : $err",
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(child: Text("Utilisateur introuvable"));
          }

          return Column(
            children: [
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user.photoUrl != null
                          ? NetworkImage(user.photoUrl!)
                          : const NetworkImage(
                        "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
                      ),
                    ),

                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user.firstName} ${user.lastName}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4F0EC),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  icon: const Icon(Icons.edit, color: Color(0xFF00897B)),
                  label: const Text(
                    "Modifier profil",
                    style: TextStyle(
                      color: Color(0xFF00897B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => context.go('/profil/edit'),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE),
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  icon: const Icon(Icons.logout, color: Color(0xFFD32F2F)),
                  label: const Text(
                    "Se déconnecter",
                    style: TextStyle(
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () async {
                    await AuthService.instance.signOut();
                    ref.invalidate(userProvider);
                    if (context.mounted) context.go('/login');
                  },
                ),
              ),
            ],
          );
        },
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
