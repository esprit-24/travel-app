import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/trip_model.dart';
import '../../../services/trip_service.dart';
import '../../../providers/admin_trips_provider.dart';

class AdminAddTripScreen extends ConsumerStatefulWidget {
  const AdminAddTripScreen({super.key});

  @override
  ConsumerState<AdminAddTripScreen> createState() =>
      _AdminAddTripScreenState();
}

class _AdminAddTripScreenState
    extends ConsumerState<AdminAddTripScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _ratingCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _countryCtrl.dispose();
    _imageCtrl.dispose();
    _priceCtrl.dispose();
    _ratingCtrl.dispose();
    _durationCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  // ============================================================
  // 🟢 ENREGISTRER VOYAGE
  // ============================================================
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final trip = Trip(
        title: _titleCtrl.text.trim(),
        country: _countryCtrl.text.trim(),
        image: _imageCtrl.text.trim(),
        price: double.parse(_priceCtrl.text),
        rating: double.parse(_ratingCtrl.text),
        duration: _durationCtrl.text.trim(),
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
      );

      await TripService.instance.createTrip(trip);

      // 🔄 Refresh liste admin
      ref.invalidate(adminTripsProvider);

      // ✅ Retour explicite (GO, pas POP)
      if (mounted) {
        context.go('/admin/trips');
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
          onPressed: () => context.go('/admin/trips'),
        ),
        title: const Text(
          "Ajouter un voyage",
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
                "Nouveau voyage",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A52),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Ajoutez un voyage organisé visible dans l’application.",
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
                      label: "Titre",
                      controller: _titleCtrl,
                      hint: "Ex: Safari au Kenya",
                    ),

                    const SizedBox(height: 12),

                    _buildInput(
                      label: "Pays / Ville",
                      controller: _countryCtrl,
                      hint: "Kenya",
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
                            hint: "1200",
                            keyboard: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInput(
                            label: "Note",
                            controller: _ratingCtrl,
                            hint: "4.8",
                            keyboard: TextInputType.number,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _buildInput(
                      label: "Durée",
                      controller: _durationCtrl,
                      hint: "Ex: 7 jours",
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
                  onPressed: () => context.go('/admin/trips'),
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
