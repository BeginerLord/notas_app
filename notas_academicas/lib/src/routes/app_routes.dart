
import 'package:flutter/material.dart';
import 'package:notas_academicas/src/screens/login_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    //home: (context) => const HomeScreen(),
    login: (context) => const LoginScreen(),
    
  };
}