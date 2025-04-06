import 'package:dio/dio.dart';

abstract class ApiInterface {
  
  // Inicialización del cliente API
  Future<void> initialize();

  // Getter para obtener el cliente Dio
  Dio get client;

  // Métodos CRUD genéricos
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String path, {dynamic data});
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters});
}
