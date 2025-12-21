import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/trip_model.dart';
import '../../../services/trip_service.dart';
import '../../../providers/admin_trips_provider.dart';

class AdminEditTripScreen extends ConsumerStatefulWidget {
  final Trip trip;

  const AdminEditTripScreen({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<AdminEditTripScreen> createState() =>
      _AdminEditTripScreenState();
}

class _AdminEditTripScreenState
    extends ConsumerState<AdminEditTripScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _countryCtrl;
  late TextEditingController _imageCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _ratingCtrl;
  late TextEditingController _durationCtrl;
  late TextEditingController _descriptionCtrl;

  bool _isLoading = false;

  // --------------------------------------------------
  // INIT
  // --------------------------------------------------
  @override
  void initState() {
    super.initState();

    final t = widget.trip;

    _titleCtrl = TextEditingController(text: t.title);
    _countryCtrl = TextEditingController(text: t.country);
    _imageCtrl = TextEditingController(text: t.image);
    _priceCtrl = TextEditingController(text: t.price.toString());
    _ratingCtrl = TextEditingController(text: t.rating.toString());
    _durationCtrl = TextEditingController(text: t.duration);
    _descriptionCtrl = TextEditingController(text: t.description ?? '');
  }

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

  // --------------------------------------------------
  // 🔄 UPDATE TRIP
  // --------------------------------------------------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedTrip = Trip(
        id: widget.trip.id,
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

      await TripService.instance
          .updateTrip(widget.trip.id!, updatedTrip);

      // 🔄 refresh liste admin
      ref.invalidate(adminTripsProvider);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Voyage mis à jour avec succès"),
          backgroundColor: Color(0xFF00897B),
        ),
      );

      context.go('/admin/trips');
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
          onPressed: () => context.go('/admin/trips'),
        ),
        title: const Text(
          "Modifier voyage",
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
              _buildInput("Titre", _titleCtrl),
              _buildInput("Pays / Ville", _countryCtrl),
              _buildInput("URL image", _imageCtrl),
              _buildInput("Prix", _priceCtrl, keyboard: TextInputType.number),
              _buildInput(
                "Note",
                _ratingCtrl,
                keyboard: TextInputType.number,
              ),
              _buildInput("Durée", _durationCtrl),

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
                          context.go('/admin/trips'),
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
