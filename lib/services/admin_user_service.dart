import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/app_user.dart';

class AdminUserService {
  AdminUserService._();
  static final AdminUserService instance = AdminUserService._();

  // 🔵 GET ALL USERS (ADMIN)
  Future<List<AppUser>> getAllUsers() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des utilisateurs");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => AppUser.fromJson(e)).toList();
  }
}
