class Professor {
  final String? uuid;
  final String username;
  final String? email;
  final String? password;
  final String telefono;
  final String especialidad;

  Professor({
    this.uuid,
    required this.username,
    this.email,
    this.password,
    required this.telefono,
    required this.especialidad,
  });

  // Constructor para crear un nuevo profesor
  factory Professor.create({
    required String username,
    required String email,
    required String password,
    required String telefono,
    required String especialidad,
  }) {
    return Professor(
      username: username,
      email: email,
      password: password,
      telefono: telefono,
      especialidad: especialidad,
    );
  }

  // Constructor mejorado que acepta tanto Map como String
  factory Professor.fromGetResponse(dynamic json) {
    // Si la respuesta es un String (mensaje de éxito), devolvemos un profesor con datos mínimos
    if (json is String) {
      // Creamos un UUID temporal basado en la fecha
      return Professor(
        uuid: 'temp-${DateTime.now().millisecondsSinceEpoch}',
        username: 'Nuevo Profesor', // Valor predeterminado
        telefono: '',
        especialidad: '',
      );
    }
    
    // Si la respuesta es un Map (JSON), procesamos normalmente
    if (json is Map<String, dynamic>) {
      // Verificar si la respuesta contiene userEntity (estructura común en APIs)
      if (json.containsKey('userEntity') && json['userEntity'] is Map) {
        final userEntity = json['userEntity'] as Map<String, dynamic>;
        return Professor(
          uuid: json['uuid'] ?? json['id'],
          username: userEntity['username'] ?? '',
          email: userEntity['email'],
          telefono: json['telefono'] ?? '',
          especialidad: json['especialidad'] ?? '',
        );
      }
      
      // Formato normal sin userEntity
      return Professor(
        uuid: json['uuid'],
        username: json['username'],
        email: json['email'],
        telefono: json['telefono'],
        especialidad: json['especialidad'],
      );
    }
    
    // Si no es ni String ni Map, lanzamos una excepción más descriptiva
    throw FormatException(
      'Se esperaba un objeto JSON o un string, pero se recibió: ${json.runtimeType}',
    );
  }

  // Convertir a JSON para crear un profesor
  Map<String, dynamic> toCreateJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'telefono': telefono,
      'especialidad': especialidad,
    };
  }

  // Convertir a JSON para actualizar un profesor
  Map<String, dynamic> toUpdateJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'telefono': telefono,
      'especialidad': especialidad,
    };
  }

  // Copia con método para actualizar campos
  Professor copyWith({
    String? uuid,
    String? username,
    String? email,
    String? password,
    String? telefono,
    String? especialidad,
  }) {
    return Professor(
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      telefono: telefono ?? this.telefono,
      especialidad: especialidad ?? this.especialidad,
    );
  }
}

// Modelo para la carga académica de un profesor
class AcademicLoad {
  final String materia;
  final int clasesPorSemana;

  AcademicLoad({
    required this.materia,
    required this.clasesPorSemana,
  });

  factory AcademicLoad.fromJson(Map<String, dynamic> json) {
    return AcademicLoad(
      materia: json['materia'] ?? '',
      clasesPorSemana: json['clasesPorSemana'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'materia': materia,
      'clasesPorSemana': clasesPorSemana,
    };
  }
}

// Modelo para la consulta de disponibilidad
class AvailabilityQuery {
  final String professorUuid;
  final String dia;
  final String horaInicio;
  final String horaFin;

  AvailabilityQuery({
    required this.professorUuid,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'professorUuid': professorUuid,
      'dia': dia,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
    };
  }
}