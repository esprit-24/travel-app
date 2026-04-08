import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/admin_users_provider.dart';
import '../../../models/app_user.dart';
import '../../../config/api_config.dart';

class AdminUsersListScreen extends ConsumerWidget {
  const AdminUsersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      // --------------------------------------------------
      // 🔹 APPBAR
      // --------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/admin'),
        ),
        title: const Text(
          "Gestion des utilisateurs",
          style: TextStyle(
            color: Color(0xFF1A3A52),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // --------------------------------------------------
      // 🔹 BODY
      // --------------------------------------------------
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: usersAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),

          error: (err, _) => Center(
            child: Text(
              "Erreur : $err",
              style: const TextStyle(color: Colors.red),
            ),
          ),

          data: (List<AppUser> users) {
            if (users.isEmpty) {
              return const Center(
                child: Text("Aucun utilisateur trouvé"),
              );
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                final imageUrl = user.photoUrl != null
                    ? "${ApiConfig.baseUrl.replaceAll('/index.php', '')}/${user.photoUrl}"
                    : null;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl) : null,
                      child:
                      imageUrl == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text("${user.firstName} ${user.lastName}"),
                    subtitle: Text(user.email),
                    trailing: Chip(
                      label: Text(user.role),
                      backgroundColor: user.role == 'admin'
                          ? Colors.red.shade100
                          : Colors.green.shade100,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
