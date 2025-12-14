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

  // URL API PC
  static const String apiBaseUrl =
      "http://localhost/esprit/travel_api/public/index.php";

  // Convertit localhost → IP compatible Android
  String _fixUrlForDevice(String url) {
    if (kIsWeb) return url;

    if (url.contains("localhost")) {
      return url.replaceFirst(
        "http://localhost",
        "http://10.151.37.195", // 👉 IP locale du PC
      );
    }

    return url;
  }

  // Ajoute anti-cache
  String _addCacheBypass(String url) {
    return "$url?v=${DateTime.now().millisecondsSinceEpoch}";
  }

  // ===========================================================================
  // 🔵 INSCRIPTION
  // ===========================================================================
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
    // Firebase
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

    // Création API (fix JSON naming)
    final ok = await _createUserInApi(newUser);
    if (!ok) throw Exception("Erreur API lors de la création utilisateur.");

    // Upload photo
    String? uploadedPhotoUrl;

    if (kIsWeb && webImageBytes != null) {
      uploadedPhotoUrl = await _uploadPhotoWeb(uid, webImageBytes);
    } else if (!kIsWeb && photoFile != null) {
      uploadedPhotoUrl = await _uploadPhotoMobile(uid, photoFile);
    }

    if (uploadedPhotoUrl != null) {
      uploadedPhotoUrl = _fixUrlForDevice(uploadedPhotoUrl);
    }

    return newUser.copyWith(photoUrl: uploadedPhotoUrl);
  }

  // ===========================================================================
  // 🔵 API CREATE USER — FIX JSON
  // ===========================================================================
  Future<bool> _createUserInApi(AppUser user) async {
    final url = Uri.parse("$apiBaseUrl/users/create");

    final body = {
      "uid": user.uid,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "phone": user.phone,
      "photoUrl": user.photoUrl,
      "role": user.role,
    };

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return res.statusCode == 201;
  }

  // ===========================================================================
  // 🔵 UPLOAD MOBILE
  // ===========================================================================
  Future<String?> _uploadPhotoMobile(String uid, File file) async {
    final url = Uri.parse("$apiBaseUrl/users/upload-photo");

    final request = http.MultipartRequest("POST", url);
    request.fields["uid"] = uid;

    request.files.add(await http.MultipartFile.fromPath("photo", file.path));

    final res = await request.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      return jsonDecode(body)["photoUrl"];
    }
    return null;
  }

  // ===========================================================================
  // 🔵 UPLOAD WEB
  // ===========================================================================
  Future<String?> _uploadPhotoWeb(String uid, Uint8List bytes) async {
    final url = Uri.parse("$apiBaseUrl/users/upload-photo");

    final request = http.MultipartRequest("POST", url);
    request.fields["uid"] = uid;

    request.files.add(
      http.MultipartFile.fromBytes(
        "photo",
        bytes,
        filename: "${uid}_profile.jpg",
      ),
    );

    final res = await request.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      return jsonDecode(body)["photoUrl"];
    }
    return null;
  }

  // ===========================================================================
  // 🔵 UPLOAD PHOTO EDIT PROFILE
  // ===========================================================================
  Future<String?> uploadPhoto(String uid, dynamic fileOrBytes) async {
    final url = Uri.parse("$apiBaseUrl/users/upload-photo");

    final request = http.MultipartRequest("POST", url);
    request.fields["uid"] = uid;

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
        await http.MultipartFile.fromPath("photo", (fileOrBytes as File).path),
      );
    }

    final res = await request.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode != 200) return null;

    String urlFixed = jsonDecode(body)["photoUrl"];
    urlFixed = _fixUrlForDevice(urlFixed);
    return urlFixed;
  }

  // ===========================================================================
  // 🔵 UPDATE USER
  // ===========================================================================
  Future<bool> updateUserInApi(AppUser user) async {
    final url = Uri.parse("$apiBaseUrl/users/update");

    final res = await http.put(
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

    return res.statusCode == 200;
  }

  // ===========================================================================
  // 🔵 GET USER — Fix URL + Anti-cache
  // ===========================================================================
  Future<AppUser?> getUserFromApi(String uid) async {
    final url = Uri.parse("$apiBaseUrl/users/get?uid=$uid");

    final res = await http.get(url);

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body);

    if (data["photo_url"] != null) {
      data["photo_url"] = _addCacheBypass(_fixUrlForDevice(data["photo_url"]));
    }

    return AppUser.fromJson(data);
  }

  // ===========================================================================
  // Firebase
  // ===========================================================================
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;
}
