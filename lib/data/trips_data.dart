import '../models/trip_model.dart';

class TripsData {
  static final List<Trip> trips = [

    Trip(
      title: "Rome",
      country: "Italie",
      image: "https://images.unsplash.com/photo-1563996768609-322da13575f3?w=400",
      price: 850,
      rating: 4.7,
      duration: "6 jours",
      description: "Visite du Colisée, du Vatican et gastronomie italienne.",
    ),

    Trip(
      title: "New York",
      country: "États-Unis",
      image: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400",
      price: 1200,
      rating: 4.8,
      duration: "7 jours",
      description: "Times Square, Statue de la Liberté, Central Park.",
    ),

    Trip(
      title: "Tokyo",
      country: "Japon",
      image: "https://images.unsplash.com/photo-1505060890686-7f88b77f6d5f?w=400",
      price: 1500,
      rating: 4.9,
      duration: "10 jours",
      description: "Culture japonaise, temples, technologie et gastronomie.",
    ),

    Trip(
      title: "Le Caire",
      country: "Égypte",
      image: "https://images.unsplash.com/photo-1500048993953-d23a436266cf?w=400",
      price: 900,
      rating: 4.6,
      duration: "5 jours",
      description: "Pyramides, musée égyptien, croisière sur le Nil.",
    ),

  ];
}
