import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/trip_model.dart';
import '../config/api_config.dart';

class TripService {
  TripService._();
  static final TripService instance = TripService._();

  // ============================================================
  // 🔵 GET ALL TRIPS
  // GET /trips
  // ============================================================
  Future<List<Trip>> getAllTrips() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/trips");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des voyages");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => Trip.fromJson(e)).toList();
  }

  // ============================================================
  // 🟢 CREATE TRIP
  // POST /trips
  // ============================================================
  Future<void> createTrip(Trip trip) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/trips");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(trip.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création du voyage");
    }
  }

  // ============================================================
  // ✏️ UPDATE TRIP
  // PUT /trips/{id}
  // ============================================================
  Future<void> updateTrip(int id, Trip trip) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/trips/$id");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(trip.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour du voyage");
    }
  }

  // ============================================================
  // 🗑 DELETE TRIP
  // DELETE /trips/{id}
  // ============================================================
  Future<void> deleteTrip(int id) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/trips/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression du voyage");
    }
  }
}
