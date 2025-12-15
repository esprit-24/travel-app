/// Modèle représentant un utilisateur de l'application.
///
/// ⚠️ Ce modèle représente les données MÉTIER
/// stockées dans le BACKEND.
/// Firebase Auth sert uniquement à l'authentification.
class UserModel {
  final int id;

  /// UID fourni par Firebase Auth
  final String firebaseUid;

  final String email;
  final String prenom;
  final String nom;
  final String? telephone;
  final String? photoUrl;

  /// USER | ADMIN
  final String role;

  /// Permet de désactiver un compte sans le supprimer
  final bool isActive;

  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.firebaseUid,
    required this.email,
    required this.prenom,
    required this.nom,
    this.telephone,
    this.photoUrl,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // ─────────────────────────────────────────────
  // 🧩 FROM JSON (API → Flutter)
  // ─────────────────────────────────────────────
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firebaseUid: json['firebase_uid'],
      email: json['email'],
      prenom: json['prenom'],
      nom: json['nom'],
      telephone: json['telephone'],
      photoUrl: json['photo_url'],
      role: json['role'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // ─────────────────────────────────────────────
  // 🧩 TO JSON (Flutter → API)
  // ─────────────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'email': email,
      'prenom': prenom,
      'nom': nom,
      'telephone': telephone,
      'photo_url': photoUrl,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // ─────────────────────────────────────────────
  // 🔧 COPY WITH (mise à jour locale)
  // ─────────────────────────────────────────────
  UserModel copyWith({
    String? prenom,
    String? nom,
    String? telephone,
    String? photoUrl,
    String? role,
    bool? isActive,
  }) {
    return UserModel(
      id: id,
      firebaseUid: firebaseUid,
      email: email,
      prenom: prenom ?? this.prenom,
      nom: nom ?? this.nom,
      telephone: telephone ?? this.telephone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // ─────────────────────────────────────────────
  // 🧠 Helpers
  // ─────────────────────────────────────────────
  bool get isAdmin => role == 'ADMIN';
  bool get isUser => role == 'USER';

  String get fullName => '$prenom $nom';
}
