import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import de la configuration du router.
// Toute la logique de navigation est centralisée dans ce fichier.
import 'config/router.dart';

/// Point d’entrée principal de l’application Flutter.
///
/// - Initialise l’environnement Flutter
/// - Enveloppe l’application dans [ProviderScope] pour Riverpod
/// - Lance le widget racine [MyApp]
///
/// ⚠️ Aucune logique métier ne doit être ajoutée ici.
void main() {
  runApp(
    const ProviderScope(
      // ProviderScope est obligatoire pour utiliser Riverpod
      // dans toute l’application.
      child: MyApp(),
    ),
  );
}

/// Widget racine de l’application.
///
/// Responsabilités :
/// - Fournir la configuration globale de l’application
/// - Initialiser le routing via Riverpod
/// - Définir le thème global
///
/// ⚠️ Ne contient PAS de logique métier.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupération du router configuré dans `config/router.dart`
    // via Riverpod.
    //
    // Toute la navigation de l’application dépend de ce router.
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      // Désactive le bandeau DEBUG en haut de l’écran
      debugShowCheckedModeBanner: false,

      // Titre de l’application (utilisé notamment sur le Web)
      title: 'Travel App',

      // Configuration du routing moderne (Navigator 2.0)
      routerConfig: router,

      // Thème global de l’application
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
