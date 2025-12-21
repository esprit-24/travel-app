class Trip {
  final int? id;
  final String title;
  final String country;
  final String image;
  final String? description;
  final double price;
  final double rating;
  final String duration;

  Trip({
    this.id,
    required this.title,
    required this.country,
    required this.image,
    this.description,
    required this.price,
    required this.rating,
    required this.duration,
  });

  // 🔁 JSON → Objet
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      country: json['country'],
      image: json['image'],
      description: json['description'],
      // Robustesse : conversion via toString() puis parse pour gérer String et num
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      duration: json['duration'],
    );
  }

  // 🔁 Objet → JSON (CREATE / UPDATE)
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "country": country,
      "image": image,
      "description": description,
      "price": price,
      "rating": rating,
      "duration": duration,
    };
  }
}
