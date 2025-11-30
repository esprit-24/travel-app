import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _newPhotoFile;        // mobile
  Uint8List? _newPhotoBytes;  // web

  late TextEditingController firstNameCtrl;
  late TextEditingController lastNameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  bool isSaving = false;
  bool isInitialized = false;

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  // 📸 Choisir photo (mobile + web)
  Future<void> _pickPhoto() async {
    final XFile? file =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (file == null) return;

    if (kIsWeb) {
      // WEB
      final bytes = await file.readAsBytes();
      setState(() {
        _newPhotoBytes = bytes;
      });
    } else {
      // MOBILE
      setState(() {
        _newPhotoFile = File(file.path);
      });
    }
  }

  // 🟦 Enregistrer modifications
  Future<void> _saveChanges(AppUser oldUser) async {
    setState(() => isSaving = true);

    // 1) Upload photo si sélectionnée
    String? newPhotoUrl = oldUser.photoUrl;

    if (_newPhotoFile != null || _newPhotoBytes != null) {
      final uploaded = await AuthService.instance.uploadPhoto(
        oldUser.uid,
        kIsWeb ? _newPhotoBytes! : _newPhotoFile!,
      );

      if (uploaded != null) newPhotoUrl = uploaded;
    }

    // 2) User mis à jour
    final updatedUser = AppUser(
      uid: oldUser.uid,
      email: oldUser.email,
      role: oldUser.role,
      firstName: firstNameCtrl.text.trim(),
      lastName: lastNameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      photoUrl: newPhotoUrl,
    );

    // 3) API update
    await AuthService.instance.updateUserInApi(updatedUser);

    // 4) Mise à jour provider
    ref.invalidate(userProvider);

    if (mounted) context.go('/profil');
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/profil'),
        ),
        title: const Text(
          'Modifier profil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A52),
          ),
        ),
      ),

      body: userAsync.when(
        loading: () =>
        const Center(child: CircularProgressIndicator(color: Color(0xFF00897B))),

        error: (err, _) =>
            Center(child: Text("Erreur : $err", style: const TextStyle(color: Colors.red))),

        data: (user) {
          if (user == null) {
            return const Center(child: Text("Utilisateur introuvable."));
          }

          if (!isInitialized) {
            firstNameCtrl = TextEditingController(text: user.firstName);
            lastNameCtrl = TextEditingController(text: user.lastName);
            emailCtrl = TextEditingController(text: user.email);
            phoneCtrl = TextEditingController(text: user.phone);
            isInitialized = true;
          }

          // ANTICACHE photo actuelle
          final photoUrl = (user.photoUrl != null)
              ? "${user.photoUrl}?v=${DateTime.now().millisecondsSinceEpoch}"
              : "https://images.unsplash.com/photo-1544005313-94ddf0286df2";

          ImageProvider avatarImage;

          if (_newPhotoFile != null) {
            avatarImage = FileImage(_newPhotoFile!);
          } else if (_newPhotoBytes != null) {
            avatarImage = MemoryImage(_newPhotoBytes!);
          } else {
            avatarImage = NetworkImage(photoUrl);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // 📸 Avatar
                GestureDetector(
                  onTap: _pickPhoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: avatarImage,
                  ),
                ),

                const SizedBox(height: 10),
                Text("Changer la photo", style: TextStyle(color: Colors.grey.shade600)),

                const SizedBox(height: 20),

                _buildField("Nom", firstNameCtrl),
                _buildField("Prénom", lastNameCtrl),
                _buildField("Email", emailCtrl, enabled: false),
                _buildField("Numéro de téléphone", phoneCtrl),

                const SizedBox(height: 20),

                // 🟩 Enregistrer
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : () => _saveChanges(user),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4F0EC),
                      foregroundColor: const Color(0xFF00897B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSaving
                        ? const CircularProgressIndicator(color: Color(0xFF00897B))
                        : const Text("Enregistrer les modifications",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () => context.go('/profil'),
                  child: Text("Annuler",
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(
      String label,
      TextEditingController controller, {
        bool enabled = true,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
