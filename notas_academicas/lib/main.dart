import 'package:flutter/material.dart';
import 'package:notas_academicas/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura inicialización antes de correr la app
  // Asegúrate de cargar dotenv antes de ejecutar la aplicación
   await dotenv.load(fileName: ".env");
  runApp(
    ProviderScope( // Permite usar Riverpod en toda la app
      child: MyApp(),
    ),
  );
}
