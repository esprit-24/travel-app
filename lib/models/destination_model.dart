class Destination {
  final String image;
  final String name;
  final String country;
  final String type; // 'hotel' ou 'restaurant'
  final String price;

  const Destination({
    required this.image,
    required this.name,
    required this.country,
    required this.price,
    required this.type,
  });
}
