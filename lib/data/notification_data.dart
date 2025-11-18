import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationData {
  static List<NotificationModel> notifications = [
    NotificationModel(
      title: "Alerte de vol",
      message: "Votre vol Paris → Rome pourrait être retardé.",
      time: "Il y a 10 min",
      icon: Icons.flight_takeoff,
      iconColor: Color(0xFF00897B),
      isRead: false,
    ),
    NotificationModel(
      title: "Météo à Barcelone",
      message: "Soleil prévu demain. Idéal pour les visites.",
      time: "Il y a 25 min",
      icon: Icons.wb_sunny_outlined,
      iconColor: Color(0xFF00897B),
      isRead: false,
    ),
    NotificationModel(
      title: "Promo hôtels",
      message: "-20% sur les séjours 4★ à Lisbonne.",
      time: "Aujourd'hui • 08:15",
      icon: Icons.hotel,
      iconColor: Color(0xFF00897B),
      isRead: true, // lu
    ),
  ];
}
