import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../services/admin_user_service.dart';

final adminUsersProvider = FutureProvider<List<AppUser>>((ref) async {
  return AdminUserService.instance.getAllUsers();
});
