import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class AdminTripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminTripCard({
    super.key,
    required this.trip,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // 🖼 IMAGE
            // --------------------------------------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                trip.image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // --------------------------------------------------
            // 📄 INFOS
            // --------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3A52),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    trip.country,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${trip.duration} • ${trip.price.toStringAsFixed(0)}€",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00897B),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        trip.rating.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --------------------------------------------------
            // ✏️ 🗑 ACTIONS
            // --------------------------------------------------
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF00897B)),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
