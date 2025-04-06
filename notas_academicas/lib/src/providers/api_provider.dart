import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/api/api_service.dart';

final apiProvider = Provider<ApiInterface>((ref) {
  final api = Api(); // Usa la implementación concreta
  api.initialize(); // Inicializa la API
  return api; // Devuelve como ApiInterface
});