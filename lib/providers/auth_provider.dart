import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';
import '../models/user_model.dart';

/// Notifier Riverpod 3 pour l'authentification
class AuthNotifier extends Notifier<AuthState> {

  @override
  AuthState build() {
    // État initial au démarrage
    return AuthState.initial();
  }

  /// Connexion réussie
  void loginSuccess(UserModel user) {
    state = state.copyWith(
      isAuthenticated: true,
      user: user,
      isLoading: false,
      errorMessage: null,
    );
  }

  /// Déconnexion
  void logout() {
    state = AuthState.initial();
  }

  /// Active / désactive le loader
  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Gestion des erreurs
  void setError(String message) {
    state = state.copyWith(
      errorMessage: message,
      isLoading: false,
    );
  }
}

/// Provider global d'authentification (Riverpod 3)
final authProvider =
NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
