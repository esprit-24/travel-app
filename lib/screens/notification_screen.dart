import 'package:flutter/material.dart';
import '../data/notification_data.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_item.dart';

// Importation de GoRouter pour avoir accès aux fonctionnalités de navigation
// comme context.go() si on voulait ajouter un lien vers une page d'inscription par exemple.
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationData.notifications;
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        // 🔹 Retour à l’accueil
        leading: TextButton(
          onPressed: () {
            context.go('/home'); // redirection vers Home
          },
          child: Text(
            'Accueil',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leadingWidth: 90,

        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A52),
          ),
        ),
      ),

      body: Column(
        children: [
          NotificationHeader(
            unreadCount: unreadCount,
            onMarkAllRead: () {
              setState(() {
                for (var n in notifications) {
                  n.isRead = true;
                }
              });
            },
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) =>
                  NotificationItem(notif: notifications[index]),
            ),
          ),
        ],
      ),
    );
  }
}
