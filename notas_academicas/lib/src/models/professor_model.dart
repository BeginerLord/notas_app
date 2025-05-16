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

  // Constructor para datos recibidos al obtener todos los profesores o uno por ID
  factory Professor.fromGetResponse(Map<String, dynamic> json) {
    return Professor(
      uuid: json['uuid'],
      username: json['username'],
      telefono: json['telefono'],
      especialidad: json['especialidad'],
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