import 'package:flutter_riverpod/legacy.dart';

/// Provider global d’authentification.
///
/// Rôle :
/// - Centraliser l’état de connexion de l’utilisateur
/// - Exposer un booléen simple utilisé dans toute l’application
///
/// Valeurs :
/// - `true`  → utilisateur connecté
/// - `false` → utilisateur non connecté
///
/// Utilisation principale :
/// - Garder / bloquer l’accès aux routes via GoRouter
///   (voir `config/router.dart`)
///
/// ⚠️ Ce provider NE gère PAS :
/// - la logique de login
/// - la persistance (token, storage, etc.)
/// - les appels API
///
/// ⚠️ Toute modification de ce provider impacte la navigation.
final authProvider = StateProvider<bool>((ref) {
  // Valeur initiale :
  // L’utilisateur n’est pas connecté au lancement de l’application.
  return false;
});
