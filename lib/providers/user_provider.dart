import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../models/app_user.dart';

/// 🔥 Stream Firebase → donne l’utilisateur Firebase en temps réel
final firebaseAuthProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// 🔥 userProvider = AppUser backend
/// ⚠️ Correction importante :
/// On attend que Firebase ait fini de charger AVANT d’appeler l’API
final userProvider = FutureProvider<AppUser?>((ref) async {
  final firebaseAuthAsync = ref.watch(firebaseAuthProvider);

  // ⏳ Firebase est encore en cours d'initialisation
  if (firebaseAuthAsync.isLoading) {
    return null;
  }

  final firebaseUser = firebaseAuthAsync.value;

  // ❌ Utilisateur non connecté
  if (firebaseUser == null) {
    return null;
  }

  // ✅ Utilisateur Firebase prêt → appel API backend
  return await AuthService.instance.getUserFromApi(firebaseUser.uid);
});
