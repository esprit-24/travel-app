import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/trip_model.dart';
import '../services/trip_service.dart';

/// ============================================================
/// 🔵 Provider principal — liste des voyages
/// ============================================================
/// - Utilisé côté USER (Home, TripsPage)
/// - Utilisé côté ADMIN (dashboard)
/// - Se rafraîchit après create / update / delete
final tripsProvider = FutureProvider<List<Trip>>((ref) async {
  return TripService.instance.getAllTrips();
});
