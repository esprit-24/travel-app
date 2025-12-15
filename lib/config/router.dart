import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// =========================
// Providers
// =========================

// Provider gérant l’état d’authentification de l’utilisateur
import '../providers/auth_provider.dart';

// =========================
// Écrans - Authentification
// =========================

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';

// =========================
// Écrans - Application
// =========================

import '../screens/home_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/search_page.dart';
import '../screens/hotel_search_page.dart';
import '../screens/restaurants_screen.dart';
import '../screens/trips_page.dart';
import '../screens/weather_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';

/// Router principal de l’application.
///
/// Rôle :
/// - Centraliser toutes les routes
/// - Gérer la navigation avec GoRouter
/// - Appliquer les règles d’accès selon l’état d’authentification
///
/// ⚠️ Aucune logique métier ici.
/// ⚠️ Toute modification doit préserver le comportement existant.
final routerProvider = Provider<GoRouter>((ref) {
  // État de connexion de l’utilisateur
  final isLoggedIn = ref.watch(authProvider);

  return GoRouter(
    /// Route initiale de l’application
    initialLocation: '/login',

    /// Gestion centralisée des redirections
    ///
    /// Règles :
    /// - Utilisateur NON connecté :
    ///   → accès uniquement à /login et /register
    /// - Utilisateur connecté :
    ///   → interdiction d’accès à /login et /register
    redirect: (context, state) {
      final goingToLogin = state.matchedLocation == '/login';
      final goingToRegister = state.matchedLocation == '/register';

      // ❌ Non connecté → redirection vers /login
      if (!isLoggedIn && !goingToLogin && !goingToRegister) {
        return '/login';
      }

      // ❌ Déjà connecté → empêcher l’accès à /login et /register
      if (isLoggedIn && (goingToLogin || goingToRegister)) {
        return '/home';
      }

      // ✅ Navigation autorisée
      return null;
    },

    /// Déclaration de toutes les routes de l’application
    routes: [

      // =========================
      // Authentification
      // =========================

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // =========================
      // Pages principales
      // =========================

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),

      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),

      // =========================
      // Fonctionnalités
      // =========================

      GoRoute(
        path: '/hotels',
        builder: (context, state) => const HotelSearchPage(),
      ),

      GoRoute(
        path: '/restaurants',
        builder: (context, state) => const RestaurantsPage(),
      ),

      GoRoute(
        path: '/voyages',
        builder: (context, state) => TripsPage(),
      ),

      GoRoute(
        path: '/meteo',
        builder: (context, state) => WeatherDetailScreen(),
      ),

      // =========================
      // Profil utilisateur
      // =========================

      GoRoute(
        path: '/profil',
        builder: (context, state) => ProfileScreen(),
      ),

      GoRoute(
        path: '/profil/edit',
        builder: (context, state) => EditProfileScreen(),
      ),
    ],
  );
});
