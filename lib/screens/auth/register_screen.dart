import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;
  String? _errorMessage;

  // MOBILE
  File? _selectedImage;

  // WEB
  Uint8List? _webImageBytes;

  final ImagePicker _imagePicker = ImagePicker();

  // ---------------------------------------------------------------------------
  // PICK IMAGE (WEB + MOBILE)
  // ---------------------------------------------------------------------------
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    if (kIsWeb) {
      // WEB → Uint8List
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _webImageBytes = bytes;
        _selectedImage = null;
      });
    } else {
      // MOBILE → File
      setState(() {
        _selectedImage = File(pickedFile.path);
        _webImageBytes = null;
      });
    }
  }

  // Libération Mémoire
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // INSCRIPTION = Firebase + API PHP + Upload photo Web/Mobile
  // ---------------------------------------------------------------------------
  Future<void> _register() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Les mots de passe ne correspondent pas.";
        });
      }
      return;
    }

    try {
      final appUser = await AuthService.instance.signUpWithEmail(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        photoFile: _selectedImage,
        webImageBytes: _webImageBytes,
        role: "user",
      );

      if (!mounted) return;

      context.go('/home');
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Une erreur est survenue lors de l'inscription.";
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Créer un compte',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A52),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              Text(
                'Travel App',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Bienvenue !',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A52),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Inscrivez-vous pour planifier et réserver vos voyages.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 20),

              // ------------------------------ FORMULAIRE ------------------------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ------- PHOTO DE PROFIL -------
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5F3),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF00897B),
                                  width: 2,
                                ),
                              ),
                              child: _webImageBytes != null
                                  ? ClipOval(
                                child: Image.memory(
                                  _webImageBytes!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              )
                                  : _selectedImage != null
                                  ? ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              )
                                  : const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Color(0xFF00897B),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ajouter une photo',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // NOM + PRÉNOM
                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            label: "Prénom",
                            controller: _firstNameController,
                            hint: "Votre prénom",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInput(
                            label: "Nom",
                            controller: _lastNameController,
                            hint: "Votre nom",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _buildInput(
                      label: "Email",
                      controller: _emailController,
                      hint: "nom@example.com",
                    ),

                    const SizedBox(height: 10),

                    _buildInput(
                      label: "Numéro de téléphone",
                      controller: _phoneController,
                      hint: "+221 77 000 00 00",
                      keyboard: TextInputType.phone,
                    ),

                    const SizedBox(height: 10),

                    _buildPasswordInput(
                      label: "Mot de passe",
                      controller: _passwordController,
                      obscure: _obscurePassword,
                      onToggle: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),

                    const SizedBox(height: 10),

                    _buildPasswordInput(
                      label: "Confirmer le mot de passe",
                      controller: _confirmPasswordController,
                      obscure: _obscureConfirmPassword,
                      onToggle: () => setState(
                            () => _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 10),
              ],

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4F0EC),
                    foregroundColor: const Color(0xFF00897B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Color(0xFF00897B),
                  )
                      : const Text(
                    'S\'inscrire',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Déjà un compte ? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF00897B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INPUT HELPERS
  // ---------------------------------------------------------------------------

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF00897B),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordInput({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 20,
              letterSpacing: 2,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF00897B),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade400,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
