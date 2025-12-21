import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/destination_model.dart';
import '../../../providers/admin_destinations_provider.dart';
import '../../../services/destination_service.dart';
import '../../../widgets/admin_destination_card.dart';

class AdminDestinationsListScreen extends ConsumerWidget {
  const AdminDestinationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final destinationsAsync = ref.watch(adminDestinationsProvider);

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
          'Gestion des destinations',
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
        child: destinationsAsync.when(
          // ⏳ Loading
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF00897B)),
          ),

          // ❌ Erreur
          error: (err, _) => Center(
            child: Text(
              "Erreur : $err",
              style: const TextStyle(color: Colors.red),
            ),
          ),

          // ✅ Data
          data: (List<Destination> destinations) {
            if (destinations.isEmpty) {
              return const Center(
                child: Text(
                  "Aucune destination enregistrée",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return Column(
              children: [
                // ➕ Ajouter (plus tard)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/admin/destinations/add');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4F0EC),
                      foregroundColor: const Color(0xFF00897B),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text("Ajouter"),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final destination = destinations[index];

                      return AdminDestinationCard(
                        destination: destination,

                        // ✏ Modifier (prochaine étape)
                        onEdit: () {
                          context.go(
                            '/admin/destinations/edit',
                            extra: destination,
                          );
                        },

                        // 🗑 Supprimer
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Confirmation"),
                              content: const Text(
                                "Voulez-vous vraiment supprimer cette destination ?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Annuler"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text("Supprimer"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await DestinationService.instance
                                .deleteDestination(destination.id!);

                            // 🔄 refresh provider
                            ref.invalidate(adminDestinationsProvider);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
