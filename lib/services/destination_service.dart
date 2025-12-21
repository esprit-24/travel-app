import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/destination_model.dart';
import '../config/api_config.dart';

class DestinationService {
  DestinationService._();
  static final DestinationService instance = DestinationService._();

  // ============================================================
  // 🔵 GET ALL DESTINATIONS (USER + ADMIN)
  // GET /destinations
  // ============================================================
  Future<List<Destination>> getAllDestinations() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/destinations");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des destinations");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => Destination.fromJson(e)).toList();
  }

  // ============================================================
  // 🟢 CREATE DESTINATION (ADMIN)
  // POST /destinations
  // ============================================================
  Future<void> createDestination(Destination destination) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/destinations");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(destination.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Erreur lors de la création de la destination");
    }
  }

  // ============================================================
  // 🟠 UPDATE DESTINATION (ADMIN)
  // PUT /destinations/{id}
  // ============================================================
  Future<void> updateDestination(Destination destination) async {
    if (destination.id == null) {
      throw Exception("ID destination manquant pour la mise à jour");
    }

    final url =
    Uri.parse("${ApiConfig.baseUrl}/destinations/${destination.id}");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(destination.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour");
    }
  }

  // ============================================================
  // 🔴 DELETE DESTINATION (ADMIN)
  // DELETE /destinations/{id}
  // ============================================================
  Future<void> deleteDestination(int id) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/destinations/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression");
    }
  }
}
