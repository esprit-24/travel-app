import 'package:flutter/material.dart';

class NotificationHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const NotificationHeader({
    super.key,
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Vos dernières alertes',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              if (unreadCount > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
            ],
          ),

          GestureDetector(
            onTap: onMarkAllRead,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Tout marquer comme lu',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00897B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
