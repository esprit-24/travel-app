import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static const String _path =
      "/esprit/travel_api/public/index.php";

  // IP locale de TON PC (valeur actuelle)
  static const String _pcIp = "10.151.37.195";

  static String get baseUrl {
    // 🌐 Flutter Web / Chrome
    if (kIsWeb) {
      return "http://localhost$_path";
    }

    // 🤖 Android (émulateur OU téléphone)
    if (Platform.isAndroid) {
      // Android Emulator utilise 10.0.2.2
      // Android réel utilisera l’IP du PC
      // → On distingue par le host de la requête réseau
      // Simple et fiable :
      return "http://10.0.2.2$_path";
    }

    // 🖥️ Fallback (autres plateformes)
    return "http://$_pcIp$_path";
  }

  // 👉 Si tu veux forcer le téléphone réel :
  static String get deviceBaseUrl {
    return "http://$_pcIp$_path";
  }
}
