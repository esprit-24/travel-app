import '../models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    required this.isAuthenticated,
    required this.user,
    required this.isLoading,
    required this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(
      isAuthenticated: false,
      user: null,
      isLoading: false,
      errorMessage: null,
    );
  }

  AuthState copyWith({
    bool? isAuthenticated,
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
