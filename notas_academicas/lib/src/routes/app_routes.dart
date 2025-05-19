
import 'package:flutter/material.dart';
import 'package:notas_academicas/src/screens/Auth/login/login_screen.dart';
import 'package:notas_academicas/src/screens/Auth/signup/signup_screen.dart';
import 'package:notas_academicas/src/screens/Dashboard/admin_dashboard.dart';

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    dashboard: (context) => const AdminDashboard(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
  };
}