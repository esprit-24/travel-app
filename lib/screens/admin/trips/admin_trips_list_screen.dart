import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/trip_model.dart';
import '../../../providers/admin_trips_provider.dart';
import '../../../services/trip_service.dart';
import '../../../widgets/admin_trip_card.dart';

class AdminTripsListScreen extends ConsumerWidget {
  const AdminTripsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(adminTripsProvider);

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
          'Gestion des voyages',
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
        child: tripsAsync.when(
          // ⏳ Chargement
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

          // ✅ Données
          data: (List<Trip> trips) {
            return Column(
              children: [
                // --------------------------------------------------
                // ➕ AJOUTER
                // --------------------------------------------------
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/admin/trips/add');
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

                // --------------------------------------------------
                // 📋 LISTE
                // --------------------------------------------------
                Expanded(
                  child: trips.isEmpty
                      ? const Center(
                    child: Text(
                      "Aucun voyage enregistré",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];

                      return AdminTripCard(
                        trip: trip,

                        // ✏️ MODIFIER
                        onEdit: () {
                          context.go(
                            '/admin/trips/edit',
                            extra: trip,
                          );
                        },

                        // 🗑 SUPPRIMER
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Confirmation"),
                              content: const Text(
                                "Voulez-vous vraiment supprimer ce voyage ?",
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
                            await TripService.instance
                                .deleteTrip(trip.id!);

                            // 🔄 Refresh
                            ref.invalidate(adminTripsProvider);
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
