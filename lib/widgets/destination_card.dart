import 'package:flutter/material.dart';
import '../models/destination_model.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📌 IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              destination.image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // 📌 TEXTE
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Nom + Prix
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        destination.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3A52),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        destination.price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00897B),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // 🔹 Pays
                Text(
                  destination.country,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 10),

                // 🔹 Rating + nombre d’avis
                Row(
                  children: [
                    // ⭐ icône étoile
                    const Icon(Icons.star, color: Color(0xFFFFC107), size: 20),

                    const SizedBox(width: 4),

                    // ⭐ Note
                    Text(
                      destination.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A3A52),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // 👥 Nombre d'avis
                    Text(
                      "(${destination.reviews} avis)",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
