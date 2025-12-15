import 'package:flutter/cupertino.dart';

/// Modèle représentant une notification utilisateur.
///
/// Utilisé pour :
/// - afficher les notifications dans l’UI
/// - gérer l’état lu / non lu
///
/// Actuellement alimenté par des fake data,
/// mais prêt pour une future intégration avec :
/// - une API
/// - une base de données
///
/// ⚠️ Aucune logique métier ici.
class NotificationModel {
  /// Titre de la notification
  final String title;

  /// Message principal
  final String message;

  /// Temps ou date affichée (format libre)
  final String time;

  /// Icône associée à la notification
  final IconData icon;

  /// Couleur de l’icône
  final Color iconColor;

  /// Indique si la notification a été lue
  bool isRead;

  /// Constructeur principal utilisé avec les fake data
  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });

  /// Crée une instance de [NotificationModel] à partir d’un JSON.
  ///
  /// ⚠️ Cette méthode N’EST PAS encore utilisée dans l’application.
  /// Elle est prévue pour une future source de données.
  ///
  /// Pour les champs complexes :
  /// - IconData → reconstruit via codePoint + fontFamily
  /// - Color → reconstruit via sa valeur entière
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] as String,
      message: json['message'] as String,
      time: json['time'] as String,
      icon: IconData(
        json['iconCodePoint'] as int,
        fontFamily: json['iconFontFamily'] as String?,
      ),
      iconColor: Color(json['iconColor'] as int),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  /// Convertit la notification en Map JSON.
  ///
  /// Utile pour :
  /// - stockage local
  /// - envoi vers une API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'time': time,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconColor': iconColor.value,
      'isRead': isRead,
    };
  }
}
