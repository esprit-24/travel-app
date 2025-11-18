import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notif;

  const NotificationItem({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icône + badge
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notif.icon,
                color: notif.iconColor,
                size: 24,
              ),
            ),

            // BADGE ROUGE → non lu
            if (!notif.isRead)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notif.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A52),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                notif.message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                notif.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
