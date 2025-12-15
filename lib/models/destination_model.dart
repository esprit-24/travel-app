/// Modèle représentant une destination affichée dans l’application.
///
/// Une destination peut être :
/// - un hôtel
/// - un restaurant
/// - une activité touristique
///
/// Ce modèle est actuellement utilisé avec des fake data,
/// mais il est prêt pour une future intégration avec :
/// - une API REST
/// - une base de données
/// - Firebase ou toute autre source JSON.
///
/// ⚠️ Aucune logique métier ici.
/// ⚠️ Ce modèle sert uniquement à structurer les données.
class Destination {
  /// Nom de la destination
  final String name;

  /// Pays où se situe la destination
  final String country;

  /// Type de destination (hotel, restaurant, activité, etc.)
  final String type;

  /// URL ou chemin de l’image associée
  final String image;

  /// Prix affiché (format libre, ex: "150€")
  ///
  /// ⚠️ Conservé volontairement en String
  /// pour ne pas impacter l’UI existante.
  final String price;

  /// Note moyenne (ex: 3.5, 4.0, 4.6)
  final double rating;

  /// Nombre total d’avis
  final int reviews;

  /// Description optionnelle
  final String? description;

  /// Constructeur principal utilisé actuellement
  /// avec les fake data.
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

  /// Crée une instance de [Destination] à partir d’un JSON.
  ///
  /// ⚠️ Cette méthode N’EST PAS encore utilisée dans l’application.
  /// Elle est ajoutée pour anticiper une future source de données
  /// (API / base de données).
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      name: json['name'] as String,
      country: json['country'] as String,
      type: json['type'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      description: json['description'] as String?,
    );
  }

  /// Convertit l’instance en Map JSON.
  ///
  /// Utile pour :
  /// - envoyer les données vers une API
  /// - stocker les données localement
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'type': type,
      'image': image,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'description': description,
    };
  }
}
