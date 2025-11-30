import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 🔥 Stream Firebase → donne l’utilisateur Firebase en temps réel
final firebaseAuthProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// 🔥 userProvider = AppUser backend + refresh automatique
final userProvider = FutureProvider<AppUser?>((ref) async {
  // 1) On écoute firebaseAuthProvider
  final firebaseUser = ref.watch(firebaseAuthProvider).value;

  if (firebaseUser == null) return null; // Déconnecté

  // 2) On récupère le user depuis ton API
  return await AuthService.instance.getUserFromApi(firebaseUser.uid);
});
