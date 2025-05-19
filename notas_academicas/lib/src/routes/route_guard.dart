import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notas_academicas/src/providers/auth_provider.dart';
import 'package:notas_academicas/src/routes/app_routes.dart';
import 'package:notas_academicas/src/screens/Auth/login/login_screen.dart';

class RouteGuard {
  static Route<dynamic> handleRoute(RouteSettings settings, WidgetRef ref) {
    final authState = ref.read(authProvider);
    final isLoggedIn = authState.isLoggedIn;
    final userRole = authState.role;

    // Lista de rutas públicas que no requieren autenticación
    final publicRoutes = [AppRoutes.login, AppRoutes.signup, AppRoutes.dashboard];
    
    // Verifica si el usuario está autenticado para rutas protegidas
    if (!isLoggedIn && !publicRoutes.contains(settings.name)) {
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    }

    // Verifica permisos basados en roles
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