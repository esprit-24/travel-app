import '../models/destination_model.dart';

/// Service responsable du filtrage et du tri des hôtels.
///
/// ❗ Aucune dépendance Flutter
/// ❗ Aucune logique UI
/// ❗ Réutilisable et testable
class HotelSearchService {
  static List<Destination> filterHotels({
    required List<Destination> destinations,
    required String selectedFilter,
    required String searchQuery,
  }) {
    // 1️⃣ On garde uniquement les hôtels
    List<Destination> hotels =
    destinations.where((d) => d.type == 'hotel').toList();

    // 2️⃣ Recherche textuelle (nom / pays)
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      hotels = hotels.where((h) {
        return h.name.toLowerCase().contains(q) ||
            h.country.toLowerCase().contains(q);
      }).toList();
    }

    // 3️⃣ Tri selon le filtre sélectionné
    switch (selectedFilter) {
      case 'Prix':
        hotels.sort((a, b) => a.price.compareTo(b.price));
        break;

      case 'Popularité':
        hotels.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;

      case 'Étoiles':
      default:
        hotels.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return hotels;
  }
}
