import 'package:flutter_riverpod/legacy.dart';

/// Provider d'authentification.
/// true  = l'utilisateur est connecté
/// false = l'utilisateur n'est pas connecté
final authProvider = StateProvider<bool>((ref) {
  return false; // valeur initiale : pas connecté
});
