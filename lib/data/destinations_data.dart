import '../models/destination_model.dart';


class DestinationsData {
  // Liste complète des hôtels
  static final List<Destination> hotels = [
    Destination(
      name: 'Hôtel Ritz Paris',
      country: 'France',
      type: 'hotel',
      image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      price: '280€',
    ),
    Destination(
      name: 'Hôtel Colosseum',
      country: 'Italie',
      type: 'hotel',
      image: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
      price: '220€',
    ),
    Destination(
      name: 'The Plaza Hotel',
      country: 'États-Unis',
      type: 'hotel',
      image: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
      price: '350€',
    ),
    Destination(
      name: 'Hôtel Marina Bay',
      country: 'Singapour',
      type: 'hotel',
      image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
      price: '300€',
    ),
    Destination(
      name: 'Burj Al Arab',
      country: 'Émirats arabes unis',
      type: 'hotel',
      image: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
      price: '450€',
    ),
    Destination(
      name: 'Hôtel Santorini',
      country: 'Grèce',
      type: 'hotel',
      image: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=400',
      price: '200€',
    ),
  ];

  // Liste complète des restaurants
  static final List<Destination> restaurants = [
    Destination(
      name: 'Le Cinq',
      country: 'Paris, France',
      type: 'restaurant',
      image: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
      price: '€',
    ),
    Destination(
      name: 'Osteria Francescana',
      country: 'Modène, Italie',
      type: 'restaurant',
      image: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=400',
      price: '€',
    ),
    Destination(
      name: 'Eleven Madison Park',
      country: 'New York, États-Unis',
      type: 'restaurant',
      image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      price: '€',
    ),
    Destination(
      name: 'Sukiyabashi Jiro',
      country: 'Tokyo, Japon',
      type: 'restaurant',
      image: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
      price: '€',
    ),
    Destination(
      name: 'El Celler de Can Roca',
      country: 'Gérone, Espagne',
      type: 'restaurant',
      image: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
      price: '€',
    ),
    Destination(
      name: 'Noma',
      country: 'Copenhague, Danemark',
      type: 'restaurant',
      image: 'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?w=400',
      price: '€',
    ),
  ];
}