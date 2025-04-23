import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_interface.dart';

class Api implements ApiInterface {
  Dio? _scheduleApi; // Cambiar a nullable para verificar si ya está inicializado

  @override
  Dio get client {
    if (_scheduleApi == null) {
      throw Exception("El cliente API no ha sido inicializado. Llama a initialize() primero.");
    }
    return _scheduleApi!;
  }

  @override
  Future<void> initialize() async {
    // Verifica si ya está inicializado
    if (_scheduleApi != null) {
      return; // Sal del método si ya está inicializado
    }

    await dotenv.load();

    final String baseUrl = dotenv.env['API_URL'] ?? '';
    final String secretKey = dotenv.env['SECRET_KEY'] ?? '';

    _scheduleApi = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'api-key': secretKey,
        },
      ),
    );

    _scheduleApi!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final String? jwt = prefs.getString('jwt');

          if (jwt != null) {
            options.headers['Authorization'] = 'Bearer $jwt';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  // Implementación de los métodos CRUD
  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return client.get(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String path, {dynamic data}) {
    return client.post(path, data: data);
  }

  @override
  Future<Response> put(String path, {dynamic data}) {
    return client.put(path, data: data);
  }

  @override
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) {
    return client.delete(path, queryParameters: queryParameters);
  }
}