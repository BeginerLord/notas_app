import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String role;

  AuthState({
    required this.isLoggedIn,
    required this.role,
  });

  // Estado inicial (usuario no autenticado)
  factory AuthState.initial() {
    return AuthState(
      isLoggedIn: false,
      role: '',
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  // Método para iniciar sesión
  void login(String role) {
    state = AuthState(
      isLoggedIn: true,
      role: role,
    );
  }

  // Método para cerrar sesión
  void logout() {
    state = AuthState.initial();
  }
}

// Proveedor de estado para la autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});