import '../models/trip_model.dart';

/// =======================================
/// Service de recherche et filtrage des voyages
/// ---------------------------------------
/// - Logique pure (sans Flutter)
/// - Aucune gestion d'état
/// - Préparé pour API / DB
/// =======================================
class TripSearchService {
  /// Filtre les voyages selon une recherche texte
  /// (titre ou pays)
  static List<Trip> filterTrips({
    required List<Trip> trips,
    required String searchQuery,
  }) {
    if (searchQuery.isEmpty) {
      return trips;
    }

    final q = searchQuery.toLowerCase();

    return trips.where((trip) {
      return trip.title.toLowerCase().contains(q) ||
          trip.country.toLowerCase().contains(q);
    }).toList();
  }
}
