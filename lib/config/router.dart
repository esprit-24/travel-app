import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Écrans
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/hotel_search_page.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/restaurants_screen.dart';
import '../screens/search_page.dart';
import '../screens/trips_page.dart';
import '../screens/weather_detail_screen.dart';

// Provider d'auth basé sur Firebase
import '../providers/auth_provider.dart';

/// Router principal
final routerProvider = Provider<GoRouter>((ref) {
  // Firebase donne l’état réel : connecté / déconnecté
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: '/login',

    debugLogDiagnostics: true, // utile pour voir les redirections

    redirect: (context, state) {
      final goingToLogin = state.matchedLocation == '/login';
      final goingToRegister = state.matchedLocation == '/register';

      // 🔐 Si NON connecté → accès interdit sauf login/register
      if (!isLoggedIn && !goingToLogin && !goingToRegister) {
        return '/login';
      }

      // 🔐 Si connecté → bloquer login/register → aller à home
      if (isLoggedIn && (goingToLogin || goingToRegister)) {
        return '/home';
      }

      return null;
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
        builder: (context, state) => TripsPage(),
      ),

      GoRoute(
        path: '/meteo',
        builder: (context, state) => WeatherDetailScreen(),
      ),

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
