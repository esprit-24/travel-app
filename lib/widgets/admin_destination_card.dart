import 'package:flutter/material.dart';
import '../models/destination_model.dart';

class AdminDestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminDestinationCard({
    super.key,
    required this.destination,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // 🖼️ Image
            // --------------------------------------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                destination.image,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 160,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // --------------------------------------------------
            // 📌 Infos principales
            // --------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3A52),
                    ),
                  ),
                ),

                // Badge type
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: destination.type == 'hotel'
                        ? Colors.blue.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    destination.type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: destination.type == 'hotel'
                          ? Colors.blue
                          : Colors.green,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              destination.country,
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 10),

            // --------------------------------------------------
            // ⭐ Infos secondaires
            // --------------------------------------------------
            Row(
              children: [
                const Icon(Icons.star, size: 18, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  destination.rating.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Text(
                  "${destination.reviews} avis",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const Spacer(),
                Text(
                  destination.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00897B),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // --------------------------------------------------
            // 🔧 Actions admin
            // --------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label: const Text(
                    "Modifier",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Supprimer",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
