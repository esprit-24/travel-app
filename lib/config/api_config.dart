import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _path = "/esprit/travel_api/public/index.php";

  // IP locale du PC (utilisée par Android réel)
  static const String _pcIp = "10.151.37.195";

  static String get baseUrl {
    // 🌐 Flutter Web
    if (kIsWeb) {
      return "http://localhost$_path";
    }

    // 🤖 Android
    if (Platform.isAndroid) {
      // DEBUG → Émulateur
      if (kDebugMode) {
        return "http://10.0.2.2$_path";
      }

      // RELEASE → Android réel
      return "http://$_pcIp$_path";
    }

    // 🖥️ Autres plateformes (fallback sûr)
    return "http://$_pcIp$_path";
  }
}
