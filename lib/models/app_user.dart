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

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      firstName: json['first_name'],      // <-- correspond à API
      lastName: json['last_name'],        // <-- correspond à API
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photo_url'],        // <-- API renvoie photo_url
      role: json['role'] ?? "user",
    );
  }
}
