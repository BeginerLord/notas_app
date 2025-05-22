class Student {
  final String? uuid;
  final String username;
  final String? email;
  final String? password;
  final String acudiente;
  final String direccion;
  final String telefono;

  Student({
    this.uuid,
    required this.username,
    this.email,
    this.password,
    required this.acudiente,
    required this.direccion,
    required this.telefono,
  });

  // Constructor para crear un nuevo estudiante
  factory Student.create({
    required String username,
    required String email,
    required String password,
    required String acudiente,
    required String direccion,
    required String telefono,
  }) {
    return Student(
      username: username,
      email: email,
      password: password,
      acudiente: acudiente,
      direccion: direccion,
      telefono: telefono,
    );
  }

  // Constructor mejorado que acepta tanto Map como String
  factory Student.fromGetResponse(dynamic json) {
    // Si la respuesta es un String (mensaje de éxito), devolvemos un estudiante con datos mínimos
    if (json is String) {
      // Creamos un UUID temporal basado en la fecha
      return Student(
        uuid: 'temp-${DateTime.now().millisecondsSinceEpoch}',
        username: 'Nuevo Estudiante', // Valor predeterminado
        acudiente: '',
        direccion: '',
        telefono: '',
      );
    }
    
    // Si la respuesta es un Map (JSON), procesamos normalmente
    if (json is Map<String, dynamic>) {
      // Verificar si la respuesta contiene userEntity (estructura común en APIs)
      if (json.containsKey('userEntity') && json['userEntity'] is Map) {
        final userEntity = json['userEntity'] as Map<String, dynamic>;
        return Student(
          uuid: json['uuid'] ?? json['id'],
          username: userEntity['username'] ?? '',
          email: userEntity['email'],
          acudiente: json['acudiente'] ?? '',
          direccion: json['direccion'] ?? '',
          telefono: json['telefono'] ?? '',
        );
      }
      
      // Formato normal sin userEntity
      return Student(
        uuid: json['uuid'],
        username: json['username'],
        email: json['email'],
        acudiente: json['acudiente'] ?? '',
        direccion: json['direccion'] ?? '',
        telefono: json['telefono'] ?? '',
      );
    }
    
    // Si no es ni String ni Map, lanzamos una excepción más descriptiva
    throw FormatException(
      'Se esperaba un objeto JSON o un string, pero se recibió: ${json.runtimeType}',
    );
  }

  // Convertir a JSON para crear un estudiante
  Map<String, dynamic> toCreateJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'acudiente': acudiente,
      'direccion': direccion,
      'telefono': telefono,
    };
  }

  // Convertir a JSON para actualizar un estudiante
  Map<String, dynamic> toUpdateJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'acudiente': acudiente,
      'direccion': direccion,
      'telefono': telefono,
    };
  }

  // Copia con método para actualizar campos
  Student copyWith({
    String? uuid,
    String? username,
    String? email,
    String? password,
    String? acudiente,
    String? direccion,
    String? telefono,
  }) {
    return Student(
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      acudiente: acudiente ?? this.acudiente,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
    );
  }
}