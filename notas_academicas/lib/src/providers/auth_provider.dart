import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notas_academicas/src/api/api_service.dart';
import 'package:notas_academicas/src/services/Auth/implementation/auth_service_impl.dart';
import 'package:notas_academicas/src/services/Auth/interfaces/i_auth_service.dart';

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

// Proveedor del servicio de autenticación basado en la interfaz
final authServiceProvider = Provider<IauthService>((ref) {
  return AuthServiceImpl(Api()); // Devuelve una implementación de IauthService
});