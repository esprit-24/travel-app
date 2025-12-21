import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/destination_model.dart';
import '../../../services/destination_service.dart';
import '../../../providers/admin_destinations_provider.dart';

class AdminEditDestinationScreen extends ConsumerStatefulWidget {
  final Destination destination;

  const AdminEditDestinationScreen({
    super.key,
    required this.destination,
  });

  @override
  ConsumerState<AdminEditDestinationScreen> createState() =>
      _AdminEditDestinationScreenState();
}

class _AdminEditDestinationScreenState
    extends ConsumerState<AdminEditDestinationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _imageCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _ratingCtrl;
  late TextEditingController _reviewsCtrl;
  late TextEditingController _descriptionCtrl;

  late String _type;
  bool _isLoading = false;

  // --------------------------------------------------
  // INIT
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();

    final d = widget.destination;

    _nameCtrl = TextEditingController(text: d.name);
    _countryCtrl = TextEditingController(text: d.country);
    _imageCtrl = TextEditingController(text: d.image);
    _priceCtrl = TextEditingController(text: d.price);
    _ratingCtrl = TextEditingController(text: d.rating.toString());
    _reviewsCtrl = TextEditingController(text: d.reviews.toString());
    _descriptionCtrl =
        TextEditingController(text: d.description ?? '');

    _type = d.type;
  }

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

  // --------------------------------------------------
  // 🔄 UPDATE DESTINATION
  // --------------------------------------------------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedDestination = Destination(
        id: widget.destination.id,
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

      await DestinationService.instance
          .updateDestination(updatedDestination);

      // 🔄 refresh liste admin
      ref.invalidate(adminDestinationsProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Destination mise à jour avec succès"),
          backgroundColor: Color(0xFF00897B),
        ),
      );

      context.go('/admin/destinations');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --------------------------------------------------
  // UI
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1A3A52)),
          onPressed: () => context.go('/admin/destinations'),
        ),
        title: const Text(
          "Modifier destination",
          style: TextStyle(
            color: Color(0xFF1A3A52),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput("Nom", _nameCtrl),
              _buildInput("Pays / Ville", _countryCtrl),
              _buildInput("URL image", _imageCtrl),
              _buildInput("Prix", _priceCtrl),
              _buildInput(
                "Note",
                _ratingCtrl,
                keyboard: TextInputType.number,
              ),
              _buildInput(
                "Nombre d’avis",
                _reviewsCtrl,
                keyboard: TextInputType.number,
              ),

              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'hotel', child: Text("Hôtel")),
                  DropdownMenuItem(
                      value: 'restaurant', child: Text("Restaurant")),
                ],
                onChanged: (v) => setState(() => _type = v!),
                decoration: const InputDecoration(labelText: "Type"),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description (optionnelle)",
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          context.go('/admin/destinations'),
                      child: const Text("Annuler"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4F0EC),
                        foregroundColor: const Color(0xFF00897B),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Enregistrer"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // INPUT HELPER
  // --------------------------------------------------
  Widget _buildInput(
      String label,
      TextEditingController controller, {
        TextInputType keyboard = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: (v) =>
        v == null || v.isEmpty ? "Champ requis" : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
