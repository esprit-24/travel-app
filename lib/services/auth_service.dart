import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String apiBaseUrl =
      "http://localhost/esprit/travel_api/public/index.php";

  // ---------------------------------------------------------------------------
  // INSCRIPTION : Firebase + API + Upload photo
  // ---------------------------------------------------------------------------
  Future<AppUser> signUpWithEmail({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,

    /// MOBILE → File
    File? photoFile,

    /// WEB → Bytes
    Uint8List? webImageBytes,

    String role = "user",
  }) async {

    // 1) Firebase Auth
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;

    // 2) Création BDD via API
    final appUser = AppUser(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
      photoUrl: null,
    );

    final ok = await _createUserInApi(appUser);

    if (!ok) throw Exception("Erreur création API");

    // 3) Upload photo si sélectionnée
    String? uploadedPhotoUrl;

    if (kIsWeb && webImageBytes != null) {
      uploadedPhotoUrl = await _uploadPhotoWeb(uid, webImageBytes);
    } else if (!kIsWeb && photoFile != null) {
      uploadedPhotoUrl = await _uploadPhotoMobile(uid, photoFile);
    }

    return AppUser(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
      photoUrl: uploadedPhotoUrl,
    );
  }

  // ---------------------------------------------------------------------------
  // API : Création utilisateur JSON
  // ---------------------------------------------------------------------------
  Future<bool> _createUserInApi(AppUser user) async {
    final url = Uri.parse("$apiBaseUrl/users/create");

    final response = await http.post(
      url,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 201;
  }

  // ---------------------------------------------------------------------------
  // API : Upload photo MOBILE
  // ---------------------------------------------------------------------------
  Future<String?> _uploadPhotoMobile(String uid, File file) async {
    final url = Uri.parse("$apiBaseUrl/users/upload-photo");

    final request = http.MultipartRequest("POST", url);
    request.fields["uid"] = uid;
    request.files.add(
      await http.MultipartFile.fromPath("photo", file.path),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(body);
      return json["photoUrl"];
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // API : Upload photo WEB
  // ---------------------------------------------------------------------------
  Future<String?> _uploadPhotoWeb(String uid, Uint8List bytes) async {
    final url = Uri.parse("$apiBaseUrl/users/upload-photo");

    final request = http.MultipartRequest("POST", url);
    request.fields["uid"] = uid;

    request.files.add(
      http.MultipartFile.fromBytes(
        'photo',
        bytes,
        filename: "${uid}_profile.jpg",
      ),
    );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(body);
      return json["photoUrl"];
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Récupération du user complet
  // ---------------------------------------------------------------------------
  Future<AppUser?> getUserFromApi(String uid) async {
    final url = Uri.parse("$apiBaseUrl/users/get?uid=$uid");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return AppUser.fromJson(jsonMap);
    }

    return null;
  }

  // Firebase Sign-in
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
