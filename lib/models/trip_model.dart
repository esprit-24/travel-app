/// Modèle représentant un voyage (Trip).
///
/// Utilisé pour :
/// - afficher les voyages disponibles
/// - présenter les détails d’un voyage
///
/// Actuellement alimenté par des fake data,
/// mais prêt pour une future intégration avec :
/// - une API REST
/// - une base de données
///
/// ⚠️ Aucune logique métier ici.
/// ⚠️ Ce modèle sert uniquement à structurer les données.
class Trip {
  /// Titre du voyage (ex : "Rome")
  final String title;

  /// Pays de destination (ex : "Italie")
  final String country;

  /// URL ou chemin de l’image associée
  final String image;

  /// Description du voyage
  ///
  /// Valeur par défaut vide pour ne pas casser l’existant.
  final String description;

  /// Prix du voyage
  final double price;

  /// Note moyenne du voyage
  final double rating;

  /// Durée du voyage (ex : "7 jours")
  final String duration;

  /// Constructeur principal utilisé actuellement
  /// avec les fake data.
  Trip({
    required this.title,
    required this.country,
    required this.image,
    this.description = "",
    required this.price,
    required this.rating,
    required this.duration,
  });

  /// Crée une instance de [Trip] à partir d’un JSON.
  ///
  /// ⚠️ Cette méthode n’est PAS encore utilisée dans l’application.
  /// Elle est ajoutée pour anticiper une future source de données.
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      title: json['title'] as String,
      country: json['country'] as String,
      image: json['image'] as String,
      description: json['description'] as String? ?? "",
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      duration: json['duration'] as String,
    );
  }

  /// Convertit l’instance de [Trip] en Map JSON.
  ///
  /// Utile pour :
  /// - stockage local
  /// - envoi vers une API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'country': country,
      'image': image,
      'description': description,
      'price': price,
      'rating': rating,
      'duration': duration,
    };
  }
}
