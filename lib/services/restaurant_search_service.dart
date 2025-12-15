import '../models/destination_model.dart';

/// =======================================
/// Service de recherche et filtrage
/// des restaurants
/// ---------------------------------------
/// - Logique pure (sans Flutter)
/// - Aucune gestion d'état
/// - Préparé pour API / DB
/// =======================================
class RestaurantSearchService {
  static List<Destination> filterRestaurants({
    required List<Destination> destinations,
    required String selectedFilter,
    required String searchQuery,
  }) {
    // 1) On ne garde que les restaurants
    List<Destination> data =
    destinations.where((d) => d.type == 'restaurant').toList();

    // 2) Filtre par type de cuisine (si différent de "Tout")
    if (selectedFilter != 'Tout') {
      final f = selectedFilter.toLowerCase();
      data = data.where((r) => r.name.toLowerCase() == f).toList();
    }

    // 3) Filtre par recherche texte
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      data = data.where((r) {
        return r.name.toLowerCase().contains(q) ||
            r.country.toLowerCase().contains(q);
      }).toList();
    }

    return data;
  }
}
