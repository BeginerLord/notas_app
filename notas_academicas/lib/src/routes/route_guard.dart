import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notas_academicas/src/providers/auth_provider.dart';
import 'package:notas_academicas/src/routes/app_routes.dart';
import 'package:notas_academicas/src/screens/Auth/login/login_screen.dart';

class RouteGuard {
static Route<dynamic> handleRoute(RouteSettings settings, WidgetRef ref) {
  final authState = ref.read(authProvider);
  final isLoggedIn = authState.isLoggedIn;
  final userRole = authState.role; // Supongamos que el rol está en el estado

  // Verifica si el usuario está autenticado
  if (!isLoggedIn && settings.name != AppRoutes.login) {
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }

  // Verifica si el usuario tiene el rol adecuado para acceder a la ruta
  if (settings.name == AppRoutes.profile && userRole != 'admin') {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('403 - Acceso denegado')),
      ),
    );
  }

  // Si la ruta existe en AppRoutes, retorna la ruta correspondiente
  final routeBuilder = AppRoutes.routes[settings.name];
  if (routeBuilder != null) {
    return MaterialPageRoute(
      builder: routeBuilder,
      settings: settings,
    );
  }

  // Si la ruta no existe, muestra una pantalla de error 404
  return MaterialPageRoute(
    builder: (context) => const Scaffold(
      body: Center(child: Text('404 - Página no encontrada')),
    ),
  );
}
}