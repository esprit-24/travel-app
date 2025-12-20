import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🔐 Provider Firebase : connecté / déconnecté
import '../providers/auth_provider.dart';

// 👤 Provider utilisateur (backend : rôle, infos)
import '../providers/user_provider.dart';

// 🔹 Écrans auth
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';

// 🔹 Écrans user
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/search_page.dart';
import '../screens/hotel_search_page.dart';
import '../screens/restaurants_screen.dart';
import '../screens/trips_page.dart';
import '../screens/weather_detail_screen.dart';

// 🔹 Écran admin
import '../screens/admin_dashboard_screen.dart';

/// ===============================================================
/// 🌐 Router principal de l’application
///
/// RÈGLES IMPORTANTES :
/// - Le router NE décide PAS entre /home et /admin
/// - Le LoginScreen gère la redirection selon le rôle
/// - Le router :
///    • bloque l’accès si non connecté
///    • protège les routes admin
/// ===============================================================
final routerProvider = Provider<GoRouter>((ref) {
  // 🔐 État Firebase : connecté / déconnecté
  final isLoggedIn = ref.watch(isLoggedInProvider);

  return GoRouter(
    initialLocation: '/login',

    debugLogDiagnostics: true, // 🔍 utile en debug

    /// -----------------------------------------------------------
    /// 🔁 REDIRECTION GLOBALE (AUTH UNIQUEMENT)
    /// -----------------------------------------------------------
    redirect: (context, state) {
      final goingToLogin = state.matchedLocation == '/login';
      final goingToRegister = state.matchedLocation == '/register';

      // ❌ NON connecté → accès interdit sauf login/register
      if (!isLoggedIn && !goingToLogin && !goingToRegister) {
        return '/login';
      }

      // ✅ CONNECTÉ → AUCUNE redirection automatique
      // 👉 Le LoginScreen décide où aller (home ou admin)

      return null;
    },

    /// -----------------------------------------------------------
    /// 🧭 ROUTES DE L’APPLICATION
    /// -----------------------------------------------------------
    routes: [
      // 🔐 AUTH
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // 👤 USER
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/profil',
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: '/profil/edit',
        builder: (context, state) => const EditProfileScreen(),
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

      // 🛠️ ADMIN (PROTÉGÉ PAR RÔLE)
      GoRoute(
        path: '/admin',

        /// 🔒 Protection par rôle (admin uniquement)
        redirect: (context, state) {
          final container = ProviderScope.containerOf(context);
          final userAsync = container.read(userProvider);

          // ⏳ En cours de chargement → ne rien faire
          if (userAsync.isLoading) return null;

          final user = userAsync.value;

          // ❌ Pas connecté
          if (user == null) return '/login';

          // ❌ Pas admin
          if (user.role != 'admin') return '/home';

          // ✅ Admin → accès autorisé
          return null;
        },

        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
  );
});
