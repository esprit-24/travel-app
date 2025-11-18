class Destination {
  final String name;
  final String country;
  final String type; // hotel, restaurant, activité...
  final String image;
  final String price;      // ex: "150€"
  final double rating;     // ⭐ 3.5, 4.0, 4.6...
  final int reviews;       // nombre d’avis → pour calculer popularité
  final String? description; // optionnel

  Destination({
    required this.name,
    required this.country,
    required this.type,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    this.description,
  });
}
