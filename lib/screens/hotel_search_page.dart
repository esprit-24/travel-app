import 'package:flutter/material.dart';
import '../widgets/custom_filter_chip.dart';
import '../widgets/hotel_card.dart';
import '../models/hotel.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({Key? key}) : super(key: key);

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  String selectedFilter = 'Étoiles';

  // Liste des hôtels
  final List<Hotel> hotels = [
    Hotel(
      name: 'Azure Palace',
      location: 'Nice, France',
      rating: 3.5,
      price: 150,
      image: 'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=400',
    ),
    Hotel(
      name: 'Grand Hôtel',
      location: 'Paris, France',
      rating: 4.2,
      price: 280,
      image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
    ),
    Hotel(
      name: 'Bella Vista',
      location: 'Rome, Italie',
      rating: 4.0,
      price: 200,
      image: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
    ),
    Hotel(
      name: 'Ocean Blue',
      location: 'Barcelone, Espagne',
      rating: 3.8,
      price: 180,
      image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400',
    ),
    Hotel(
      name: 'Royal Crown',
      location: 'London, UK',
      rating: 4.5,
      price: 350,
      image: 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
    ),
    Hotel(
      name: 'Sunset Resort',
      location: 'Miami, USA',
      rating: 4.1,
      price: 220,
      image: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400',
    ),
    Hotel(
      name: 'Mountain View',
      location: 'Zurich, Suisse',
      rating: 3.9,
      price: 190,
      image: 'https://images.unsplash.com/photo-1496417263034-38ec4f0b665a?w=400',
    ),
    Hotel(
      name: 'City Center',
      location: 'Berlin, Allemagne',
      rating: 3.7,
      price: 120,
      image: 'https://images.unsplash.com/photo-1445019980597-93fa8acb246c?w=400',
    ),
    Hotel(
      name: 'Riverside Inn',
      location: 'Amsterdam, Pays-Bas',
      rating: 4.3,
      price: 250,
      image: 'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=400',
    ),
    Hotel(
      name: 'Paradise Hotel',
      location: 'Bali, Indonésie',
      rating: 4.4,
      price: 300,
      image: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400',
    ),
    Hotel(
      name: 'Golden Palace',
      location: 'Dubai, UAE',
      rating: 4.6,
      price: 450,
      image: 'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?w=400',
    ),
    Hotel(
      name: 'Maple Suites',
      location: 'Toronto, Canada',
      rating: 3.6,
      price: 160,
      image: 'https://images.unsplash.com/photo-1549294413-26f195200c16?w=400',
    ),
    Hotel(
      name: 'Harbor View',
      location: 'Sydney, Australie',
      rating: 4.2,
      price: 270,
      image: 'https://images.unsplash.com/photo-1566195992011-5f6b21e539aa?w=400',
    ),
    Hotel(
      name: 'Alpine Lodge',
      location: 'Interlaken, Suisse',
      rating: 4.0,
      price: 210,
      image: 'https://images.unsplash.com/photo-1455587734955-081b22074882?w=400',
    ),
    Hotel(
      name: 'Emerald Hotel',
      location: 'Dublin, Irlande',
      rating: 3.8,
      price: 170,
      image: 'https://images.unsplash.com/photo-1517840901100-8179e982acb7?w=400',
    ),
  ];

  List<Hotel> _getSortedHotels() {
    final sortedHotels = List<Hotel>.from(hotels);

    if (selectedFilter == 'Étoiles') {
      sortedHotels.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (selectedFilter == 'Prix') {
      sortedHotels.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedFilter == 'Popularité') {
      sortedHotels.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return sortedHotels;
  }

  @override
  Widget build(BuildContext context) {
    final sortedHotels = _getSortedHotels();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () {},
        ),
        title: const Text(
          'Hôtels',
          style: TextStyle(
            color: Color(0xFF1A3A52),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un hôtel...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Filtres
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                CustomFilterChip(
                  label: 'Étoiles',
                  isSelected: selectedFilter == 'Étoiles',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Étoiles';
                    });
                  },
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: 'Prix',
                  isSelected: selectedFilter == 'Prix',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Prix';
                    });
                  },
                ),
                const SizedBox(width: 8),
                CustomFilterChip(
                  label: 'Popularité',
                  isSelected: selectedFilter == 'Popularité',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Popularité';
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // En-tête des résultats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Résultats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A52),
                  ),
                ),
                Text(
                  '${sortedHotels.length} hôtels',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Liste des hôtels
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: sortedHotels.length,
              itemBuilder: (context, index) {
                final hotel = sortedHotels[index];
                return HotelCard(hotel: hotel);
              },
            ),
          ),
        ],
      ),
    );
  }
}