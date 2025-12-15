import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

// Screens
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/search_page.dart';
import '../screens/hotel_search_page.dart';
import '../screens/restaurants_screen.dart';
import '../screens/trips_page.dart';
import '../screens/weather_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';

/// Router principal de l'application
final routerProvider = Provider<GoRouter>((ref) {
  // 🔐 On écoute l'état d'authentification
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',

    // 🔁 Redirections automatiques selon l'état d'auth
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;

      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToRegister = state.matchedLocation == '/register';

      // 🔒 NON CONNECTÉ
      if (!isLoggedIn) {
        // autorisé uniquement vers login / register
        if (!isGoingToLogin && !isGoingToRegister) {
          return '/login';
        }
      }

      // 🔓 CONNECTÉ
      if (isLoggedIn) {
        // empêche retour vers login / register
        if (isGoingToLogin || isGoingToRegister) {
          return '/home';
        }
      }

      return null; // pas de redirection
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
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
        builder: (context, state) => const TripsPage(),
      ),
      GoRoute(
        path: '/meteo',
        builder: (context, state) => const WeatherDetailScreen(),
      ),
      GoRoute(
        path: '/profil',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profil/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
});
