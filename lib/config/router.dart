import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_app/screens/hotel_search_page.dart';
import 'package:travel_app/screens/notification_screen.dart';
import 'package:travel_app/screens/restaurants_screen.dart';
import 'package:travel_app/screens/search_page.dart';
import 'package:travel_app/screens/trips_page.dart';

// Provider d'auth
import '../providers/auth_provider.dart';

// Écrans
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';

/// Router principal de l'app
final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {
      final goingToLogin = state.matchedLocation == '/login';
      final goingToRegister = state.matchedLocation == '/register';

      // Si pas connecté → uniquement /login ou /register accessible
      if (!isLoggedIn && !goingToLogin && !goingToRegister) {
        return '/login';
      }

      // Si connecté et il va sur /login ou /register → envoyer à /home
      if (isLoggedIn && (goingToLogin || goingToRegister)) {
        return '/home';
      }

      return null;
    },

    routes: [

      // Route pour la Connexion
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Route pour l'Inscription
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Route pour la page d'Accueil
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Route pour la page Notification
      GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationScreen(),
      ),

      // Route pour la page Recherche
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),

      // Route pour la page hotels
      GoRoute(
        path: '/hotels',
        builder: (context, state) => const HotelSearchPage(),
      ),

      // Route pour la page restaurants
      GoRoute(
        path: '/restaurants',
        builder: (context, state) => const RestaurantsPage(),
      ),

      // Route pour la page voyages
      GoRoute(
        path: '/voyages',
        builder: (context, state) =>  TripsPage(),
      ),

    ],
  );
});
