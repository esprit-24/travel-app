import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔗 Base URL de l'API PHP
  static const String apiBaseUrl =
      "http://localhost/esprit/travel_api/public/index.php";

  // ---------------------------------------------------------------------------
  // INSCRIPTION (Firebase + API PHP)
  // ---------------------------------------------------------------------------
  Future<AppUser> signUpWithEmail({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    File? photoFile,
    String role = "user",
  }) async {
    // 1) Création du compte dans Firebase Auth
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;

    // 2) Appel API PHP → create user
    final appUser = AppUser(
      uid: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
      photoUrl: null,
    );

    final created = await _createUserInApi(appUser);

    if (!created) {
      throw Exception("Erreur lors de la création dans l'API.");
    }

    // 3) Upload photo si sélectionnée
    String? uploadedPhotoUrl;
    if (photoFile != null) {
      uploadedPhotoUrl = await _uploadPhoto(uid, photoFile);
    }

    // 4) Retourne le user complet
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
  // APPEL API : création utilisateur (JSON)
  // ---------------------------------------------------------------------------
  Future<bool> _createUserInApi(AppUser user) async {
    final url = Uri.parse("$apiBaseUrl/users/create");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(user.toJson()),
    );

    return response.statusCode == 201;
  }

  // ---------------------------------------------------------------------------
  // APPEL API : upload photo (multipart/form-data)
  // ---------------------------------------------------------------------------
  Future<String?> _uploadPhoto(String uid, File file) async {
    final url = Uri.parse("$apiBaseUrl/users/upload-photo");

    final request = http.MultipartRequest("POST", url);

    request.fields["uid"] = uid;
    request.files.add(await http.MultipartFile.fromPath("photo", file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final json = jsonDecode(body);
      return json["photoUrl"];
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // CONNEXION Firebase
  // ---------------------------------------------------------------------------
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ---------------------------------------------------------------------------
  // DÉCONNEXION
  // ---------------------------------------------------------------------------
  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
