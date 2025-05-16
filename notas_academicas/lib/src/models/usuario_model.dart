// Modelo base para todos los usuarios
abstract class Usuario {
  final String username;
  final String email;
  final String password;
  final String telefono;

  Usuario({
    required this.username,
    required this.email,
    required this.password,
    required this.telefono,
  });

  Map<String, dynamic> toJson();
}

// Modelo específico para estudiantes
class Estudiante extends Usuario {
  final String acudiente;
  final String direccion;

  Estudiante({
    required super.username,
    required super.email,
    required super.password,
    required super.telefono,
    required this.acudiente,
    required this.direccion,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'telefono': telefono,
      'acudiente': acudiente,
      'direccion': direccion,
      'rol': 'estudiante',
    };
  }
}

// Modelo específico para profesores
class Profesor extends Usuario {
  final String especialidad;

  Profesor({
    required super.username,
    required super.email,
    required super.password,
    required super.telefono,
    required this.especialidad,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'telefono': telefono,
      'especialidad': especialidad,
      'rol': 'profesor',
    };
  }
}
