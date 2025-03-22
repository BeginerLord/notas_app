
/* 
import 'package:flutter/material.dart';
import 'package:api_to_connet/routes/app_routes.dart';
import 'package:api_to_connet/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authProvider).isLoggedIn;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Aplicación',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: AppRoutes.routes,
    );
  }
}

*/