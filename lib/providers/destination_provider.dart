import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/destination_model.dart';
import '../services/destination_service.dart';

final destinationsProvider = FutureProvider<List<Destination>>((ref) async {
  return DestinationService.instance.getAllDestinations();
});
