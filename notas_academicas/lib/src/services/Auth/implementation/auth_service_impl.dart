import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/models/user_model.dart';
import 'package:notas_academicas/src/services/Auth/interfaces/i_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class AuthServiceImpl implements IauthService {
  final ApiInterface api; // Interfaz para hacer peticiones HTTP (como Dio personalizado)
  bool _isInitialized = false; // Indicador de inicialización
  // Constructor que recibe la instancia de la API
  AuthServiceImpl(this.api);

   Future<void> initializeApi() async {
    if (_isInitialized) return; // Evita inicializaciones repetidas
    await api.initialize();
    _isInitialized = true;
  }
  
  @override
  Future<Map<String, dynamic>> signup(SignupRequest signupRequest) async {
    // Convierte el modelo a JSON
    final requestData = signupRequest.toJson();

    // Realiza la solicitud POST al endpoint '/signup'
    final response = await api.post('/signup', data: requestData);

    // Retorna la respuesta del servidor
    return response.data;
  }
  
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Realiza una petición POST a la ruta '/login' con los datos enviados
    final response = await api.post('/login', data: {
      'email': email,
      'password': password,
    });

    // Extrae los datos del response (espera un JSON con el JWT incluido)
    final data = response.data;

    // Extrae el token JWT del cuerpo de la respuesta
    final String accessToken = data['accessToken'];

    // Obtiene la instancia de SharedPreferences para guardar el token localmente
    final prefs = await SharedPreferences.getInstance();

    // Guarda el JWT en almacenamiento local (clave 'jwt') para futuros usos
    await prefs.setString('accessToken', accessToken);

     // Decodifica el JWT para extraer el rol del usuario
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    final String role = decodedToken['role'] ?? 'UNKNOWN_ROLE'; // Maneja el caso donde no exista el campo 'role'

    // Retorna un mapa con el token y el rol
    return {
      'accessToken': accessToken,
      'role': role,
    };
  
  }

 
}



