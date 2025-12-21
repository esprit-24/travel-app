import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/destination_model.dart';
import '../../../services/destination_service.dart';
import '../../../providers/admin_destinations_provider.dart';

class AdminAddDestinationScreen extends ConsumerStatefulWidget {
  const AdminAddDestinationScreen({super.key});

  @override
  ConsumerState<AdminAddDestinationScreen> createState() =>
      _AdminAddDestinationScreenState();
}

class _AdminAddDestinationScreenState
    extends ConsumerState<AdminAddDestinationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _ratingCtrl = TextEditingController();
  final _reviewsCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  String _type = 'hotel';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _countryCtrl.dispose();
    _imageCtrl.dispose();
    _priceCtrl.dispose();
    _ratingCtrl.dispose();
    _reviewsCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  // ============================================================
  // 🟢 ENREGISTRER DESTINATION
  // ============================================================
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final destination = Destination(
        name: _nameCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
        type: _type,
        image: _imageCtrl.text.trim(),
        price: _priceCtrl.text.trim(),
        rating: double.parse(_ratingCtrl.text),
        reviews: int.parse(_reviewsCtrl.text),
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
      );

      await DestinationService.instance.createDestination(destination);

      // 🔄 Refresh liste admin
      ref.invalidate(adminDestinationsProvider);

      // ✅ Retour explicite (GO, pas POP)
      if (mounted) {
        context.go('/admin/destinations');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ============================================================
  // 🧱 UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/admin/destinations'),
        ),
        title: const Text(
          "Ajouter une destination",
          style: TextStyle(
            color: Color(0xFF1A3A52),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Nouvelle destination",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A52),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Ajoutez un hôtel ou un restaurant visible dans l’application.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 24),

              // ------------------ FORMULAIRE ------------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildInput(
                      label: "Nom",
                      controller: _nameCtrl,
                      hint: "Ex: Hôtel Ritz Paris",
                    ),

                    const SizedBox(height: 12),

                    _buildInput(
                      label: "Pays / Ville",
                      controller: _countryCtrl,
                      hint: "Paris, France",
                    ),

                    const SizedBox(height: 12),

                    _buildInput(
                      label: "URL image",
                      controller: _imageCtrl,
                      hint: "https://images.unsplash.com/...",
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            label: "Prix",
                            controller: _priceCtrl,
                            hint: "150€",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInput(
                            label: "Note",
                            controller: _ratingCtrl,
                            hint: "4.5",
                            keyboard: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildInput(
                      label: "Nombre d’avis",
                      controller: _reviewsCtrl,
                      hint: "320",
                      keyboard: TextInputType.number,
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _type,
                      items: const [
                        DropdownMenuItem(
                          value: 'hotel',
                          child: Text("Hôtel"),
                        ),
                        DropdownMenuItem(
                          value: 'restaurant',
                          child: Text("Restaurant"),
                        ),
                      ],
                      onChanged: (v) => setState(() => _type = v!),
                      decoration: const InputDecoration(
                        labelText: "Type",
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: _descriptionCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description (optionnel)",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ------------------ BOUTON ENREGISTRER ------------------
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
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
                    "Enregistrer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ------------------ ANNULER ------------------
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () => context.go('/admin/destinations'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                  ),
                  child: const Text(
                    "Annuler",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🔧 INPUT STYLE (ALIGNÉ REGISTER)
  // ============================================================
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
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          validator: (v) =>
          v == null || v.isEmpty ? "Champ requis" : null,
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
}
