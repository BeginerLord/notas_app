import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/providers/auth_provider.dart';
import 'package:notas_academicas/src/services/Auth/interfaces/i_auth_service.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';

class UseLogin {
  final WidgetRef ref;
  final IauthService authService;

  UseLogin(this.ref, this.authService) {
    _initializeApi();
  }
Future<void> _initializeApi() async {
    await (authService as dynamic).initializeApi();
  }

  Future<void> login(String email, String password) async {
    // Actualiza el estado de carga en el queryProvider
    ref.read(queryProvider.notifier).fetchData(() async {
      // Llama al servicio de autenticación para iniciar sesión
      final response = await authService.login(email, password);

      // Actualiza el estado global de autenticación
      ref.read(authProvider.notifier).login(response['role']);

      return response; // Retorna la respuesta para el queryProvider
    });
  }
}