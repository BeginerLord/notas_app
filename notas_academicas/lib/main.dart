
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura inicialización antes de correr la app

  runApp(
    ProviderScope( // Permite usar Riverpod en toda la app
      child: MyApp(),
    ),
  );
}

*/