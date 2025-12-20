import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../config/api_config.dart';

/// ===============================================================
/// 🔐 AuthService
/// - Gère l’authentification Firebase
/// - Gère la communication avec l’API PHP (users)
/// - Compatible : Web / Android Emulator / Android réel
/// ===============================================================
class AuthService {
  /// Singleton
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ===============================================================
  // 🔵 INSCRIPTION
  // ===============================================================
  Future<AppUser> signUpWithEmail({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    File? photoFile,
    Uint8List? webImageBytes,
    String role = "user",
  }) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;

    final newUser = AppUser(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
      photoUrl: null,
    );

    final created = await _createUserInApi(newUser);
    if (!created) {
      throw Exception("Erreur API lors de la création utilisateur.");
    }

    String? uploadedPhotoPath;

    if (kIsWeb && webImageBytes != null) {
      uploadedPhotoPath = await _uploadPhotoWeb(uid, webImageBytes);
    } else if (!kIsWeb && photoFile != null) {
      uploadedPhotoPath = await _uploadPhotoMobile(uid, photoFile);
    }

    return newUser.copyWith(photoUrl: uploadedPhotoPath);
  }

  // ===============================================================
  // 🔵 CREATE USER — API
  // ===============================================================
  Future<bool> _createUserInApi(AppUser user) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/create");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "uid": user.uid,
        "firstName": user.firstName,
        "lastName": user.lastName,
        "email": user.email,
        "phone": user.phone,
        "photoUrl": user.photoUrl,
        "role": user.role,
      }),
    );

    return response.statusCode == 201;
  }

  // ===============================================================
  // 🔵 UPLOAD PHOTO — MOBILE
  // ===============================================================
  Future<String?> _uploadPhotoMobile(String uid, File file) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/upload-photo");

    final request = http.MultipartRequest("POST", url)
      ..fields["uid"] = uid
      ..files.add(await http.MultipartFile.fromPath("photo", file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // ✅ CORRECTION ICI
      return jsonDecode(body)["photoPath"];
    }
    return null;
  }

  // ===============================================================
  // 🔵 UPLOAD PHOTO — WEB
  // ===============================================================
  Future<String?> _uploadPhotoWeb(String uid, Uint8List bytes) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/upload-photo");

    final request = http.MultipartRequest("POST", url)
      ..fields["uid"] = uid
      ..files.add(
        http.MultipartFile.fromBytes(
          "photo",
          bytes,
          filename: "${uid}_profile.jpg",
        ),
      );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // ✅ CORRECTION ICI
      return jsonDecode(body)["photoPath"];
    }
    return null;
  }

  // ===============================================================
  // 🔵 UPLOAD PHOTO (édition profil)
  // ===============================================================
  Future<String?> uploadPhoto(String uid, dynamic fileOrBytes) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/upload-photo");

    final request = http.MultipartRequest("POST", url)
      ..fields["uid"] = uid;

    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "photo",
          fileOrBytes,
          filename: "${uid}_profile.jpg",
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          "photo",
          (fileOrBytes as File).path,
        ),
      );
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      // ✅ CORRECTION ICI
      return jsonDecode(body)["photoPath"];
    }
    return null;
  }

  // ===============================================================
  // 🔵 UPDATE USER — API
  // ===============================================================
  Future<bool> updateUserInApi(AppUser user) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/update");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "uid": user.uid,
        "first_name": user.firstName,
        "last_name": user.lastName,
        "phone": user.phone,
        "photo_url": user.photoUrl,
      }),
    );

    return response.statusCode == 200;
  }

  // ===============================================================
  // 🔵 GET USER — API
  // ===============================================================
  Future<AppUser?> getUserFromApi(String uid) async {
    final url = Uri.parse("${ApiConfig.baseUrl}/users/get?uid=$uid");

    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    return AppUser.fromJson(jsonDecode(response.body));
  }

  // ===============================================================
  // 🔵 Firebase helpers
  // ===============================================================
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;
}
