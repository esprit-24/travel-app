import '../models/trip_model.dart';

class TripsData {
  static final List<Trip> trips = [
    Trip(
      title: "New York",
      country: "États-Unis",
      image:
          "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400",
      price: 1200,
      rating: 4.8,
      duration: "7 jours",
      description: "Times Square, Statue de la Liberté, Central Park.",
    ),

    Trip(
      title: "Le Caire",
      country: "Égypte",
      image:
          "https://images.unsplash.com/photo-1500048993953-d23a436266cf?w=400",
      price: 900,
      rating: 4.6,
      duration: "5 jours",
      description: "Pyramides, musée égyptien, croisière sur le Nil.",
    ),
  ];
}
