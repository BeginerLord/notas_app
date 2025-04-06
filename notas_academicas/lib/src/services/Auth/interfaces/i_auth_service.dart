import 'package:notas_academicas/src/models/user_model.dart';

abstract class IauthService {
  // Método para registrar un usuario
  Future<Map<String, dynamic>> signup(SignupRequest signupRequest);

  // Método para iniciar sesión
  Future<Map<String, dynamic>> login(String email, String password);
}