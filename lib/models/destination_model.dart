class Destination {
  final int? id;
  final String name;
  final String country;
  final String type;
  final String image;
  final String price;
  final double rating;
  final int reviews;
  final String? description;

  Destination({
    this.id,
    required this.name,
    required this.country,
    required this.type,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    this.description,
  });

  // 🔁 JSON → Objet (ROBUSTE)
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      name: json['name'] as String,
      country: json['country'] as String,
      type: json['type'] as String,
      image: json['image'] as String,
      price: json['price'] as String,

      // ✅ FIX ICI
      rating: json['rating'] is num
          ? (json['rating'] as num).toDouble()
          : double.parse(json['rating'].toString()),

      reviews: json['reviews'] is num
          ? (json['reviews'] as num).toInt()
          : int.parse(json['reviews'].toString()),

      description: json['description'],
    );
  }

  // 🔁 Objet → JSON (admin plus tard)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "country": country,
      "type": type,
      "image": image,
      "price": price,
      "rating": rating,
      "reviews": reviews,
      "description": description,
    };
  }
}
