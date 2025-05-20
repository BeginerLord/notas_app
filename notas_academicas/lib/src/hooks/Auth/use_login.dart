import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/providers/auth_provider.dart';
import 'package:notas_academicas/src/services/Auth/implementation/auth_service_impl.dart';
import 'package:notas_academicas/src/services/Auth/interfaces/i_auth_service.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de autenticación
final authServiceProvider = Provider<IauthService>((ref) {
  final api = ref.watch(apiProvider);
  return AuthServiceImpl(api);
});

class UseLogin {
  final WidgetRef ref;
  final IauthService authService;
  final _loginProvider = queryProviderFamily<Map<String, dynamic>>();

  UseLogin(this.ref)
      : authService = ref.read(authServiceProvider) {
    _initializeApi();
  }

  String _getProviderKey(String email) => 'login_$email';

  Future<void> _initializeApi() async {
    await (authService as dynamic).initializeApi();
  }

  Future<void> login(String email, String password) async {
    final key = _getProviderKey(email);
    final notifier = ref.read(_loginProvider(key).notifier);
    
    try {
      await notifier.fetchData(() async {
        // Llama al servicio de autenticación para iniciar sesión
        final response = await authService.login(email, password);
        
        // Actualiza el estado global de autenticación
        ref.read(authProvider.notifier).login(response['role']);
        
        // Notifica al usuario del éxito
        Fluttertoast.showToast(
          msg: "¡Inicio de sesión exitoso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        
        return response;
      });
      
      // Si llegamos aquí, la operación fue exitosa
    } catch (error) {
      // Manejo de errores y notificación
      Fluttertoast.showToast(
        msg: "Error al iniciar sesión: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow; // Relanza para manejo adicional
    }
  }
  
  // Obtener el estado actual de la operación de login
  QueryState<Map<String, dynamic>> getState(String email) {
    final key = _getProviderKey(email);
    return ref.watch(_loginProvider(key));
  }
  
  // Para invalidar el estado (útil para logout o reintento)
  void invalidate(String email) {
    final key = _getProviderKey(email);
    ref.invalidate(_loginProvider(key));
  }
}

// Extension para facilitar el uso en widgets
extension LoginHooksExtension on BuildContext {
  UseLogin get useLogin {
    final ref = ProviderScope.containerOf(this) as WidgetRef;
    return UseLogin(ref);
  }
}