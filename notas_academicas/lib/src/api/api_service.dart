import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_interface.dart';

class Api implements ApiInterface {
  late final Dio _scheduleApi;

  @override
  Dio get client => _scheduleApi;

  @override
  Future<void> initialize() async {
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

    _scheduleApi.interceptors.add(
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
    return _scheduleApi.get(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String path, {dynamic data}) {
    return _scheduleApi.post(path, data: data);
  }

  @override
  Future<Response> put(String path, {dynamic data}) {
    return _scheduleApi.put(path, data: data);
  }

  @override
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) {
    return _scheduleApi.delete(path, queryParameters: queryParameters);
  }
}