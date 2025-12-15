import '../models/destination_model.dart';

/// =======================================
/// Service de recherche & filtrage
/// ---------------------------------------
/// - Aucune dépendance Flutter
/// - Logique pure (testable)
/// - Prête pour API / DB plus tard
/// =======================================
class DestinationSearchService {
  /// Filtre une liste de destinations selon :
  /// - un filtre (Tout / Hôtels / Restaurants)
  /// - une requête texte (nom ou pays)
  static List<Destination> filterDestinations({
    required List<Destination> destinations,
    required String selectedFilter,
    required String searchQuery,
  }) {
    List<Destination> results = [...destinations];

    // 🔹 Filtre par type
    if (selectedFilter == 'Hôtels') {
      results = results.where((d) => d.type == 'hotel').toList();
    } else if (selectedFilter == 'Restaurants') {
      results = results.where((d) => d.type == 'restaurant').toList();
    } else {
      // "Tout" → comportement IDENTIQUE à avant
      results.shuffle();
    }

    // 🔹 Filtre par texte
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      results = results.where((d) {
        return d.name.toLowerCase().contains(q) ||
            d.country.toLowerCase().contains(q);
      }).toList();
    }

    return results;
  }
}
