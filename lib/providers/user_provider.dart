import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/app_user.dart';

final userProvider = FutureProvider<AppUser?>((ref) async {
  final firebaseUser = AuthService.instance.currentUser;

  if (firebaseUser == null) return null;

  return await AuthService.instance.getUserFromApi(firebaseUser.uid);
});
