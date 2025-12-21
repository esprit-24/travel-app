import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/trip_model.dart';
import '../services/trip_service.dart';

/// ============================================================
/// 🔐 Provider ADMIN — Liste des voyages
/// ============================================================
final adminTripsProvider = FutureProvider<List<Trip>>((ref) async {
  return TripService.instance.getAllTrips();
});
