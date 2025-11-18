class Trip {
  final String title;       // Exemple : "Rome"
  final String country;     // Exemple : "Italie"
  final String image;       // URL de l'image
  final String description; // Optionnel mais utile
  final double price;       // Prix du voyage
  final double rating;      // Note (comme les hôtels)
  final String duration;    // Durée : "7 jours"

  Trip({
    required this.title,
    required this.country,
    required this.image,
    this.description = "",
    required this.price,
    required this.rating,
    required this.duration,
  });
}
