class AppUser {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? photoUrl;
  final String role;

  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.role = "user",
  });

  // Convertir vers JSON (pour l'API)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  // Convertir JSON -> AppUser (depuis API)
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo_url'],
      role: json['role'] ?? "user",
    );
  }

  // 🔥 Permet de cloner un user et changer un seul champ
  AppUser copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? photoUrl,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      role: role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
