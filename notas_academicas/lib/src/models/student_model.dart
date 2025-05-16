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

  // Constructor para datos recibidos al obtener todos los estudiantes o uno por ID
  factory Student.fromGetResponse(Map<String, dynamic> json) {
    return Student(
      uuid: json['uuid'],
      username: json['username'],
      acudiente: json['acudiente'],
      direccion: json['direccion'],
      telefono: json['telefono'],
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