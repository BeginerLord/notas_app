class Note {
  final int? id;
  final String? studentName;
  final double valor;
  final String periodo;
  final String? professorUsername;
  final String? studentUuid;

  Note({
    this.id,
    this.studentName,
    required this.valor,
    required this.periodo,
    this.professorUsername,
    this.studentUuid,
  });

  // Constructor para crear una nueva nota (general)
  factory Note.create({
    required double valor,
    required String periodo,
  }) {
    return Note(
      valor: valor,
      periodo: periodo,
    );
  }

  // Constructor para crear una nota asignada a un estudiante
  factory Note.forStudent({
    required double valor,
    required String periodo,
    required String studentUuid,
  }) {
    return Note(
      valor: valor,
      periodo: periodo,
      studentUuid: studentUuid,
    );
  }

  // Constructor mejorado que acepta tanto Map como String
  factory Note.fromGetResponse(dynamic json) {
    // Si la respuesta es un String (mensaje de éxito), devolvemos una nota con datos mínimos
    if (json is String) {
      return Note(
        id: null,
        valor: 0.0,
        periodo: 'Nuevo Periodo', // Valor predeterminado
      );
    }
    
    // Si la respuesta es un Map (JSON), procesamos normalmente
    if (json is Map<String, dynamic>) {
      return Note(
        id: json['id'],
        studentName: json['studentName'],
        valor: (json['valor'] is int) 
            ? (json['valor'] as int).toDouble() 
            : (json['valor'] ?? 0.0),
        periodo: json['periodo'] ?? '',
        professorUsername: json['professorUsername'],
        studentUuid: json['studentUuid'],
      );
    }
    
    // Si no es ni String ni Map, lanzamos una excepción más descriptiva
    throw FormatException(
      'Se esperaba un objeto JSON o un string, pero se recibió: ${json.runtimeType}',
    );
  }

  // Convertir a JSON para crear una nota
  Map<String, dynamic> toCreateJson() {
    return {
      'valor': valor,
      'periodo': periodo,
      if (studentUuid != null) 'studentUuid': studentUuid,
    };
  }

  // Convertir a JSON para actualizar una nota
  Map<String, dynamic> toUpdateJson() {
    return {
      'valor': valor,
      'periodo': periodo,
      if (studentUuid != null) 'studentUuid': studentUuid,
    };
  }

  // Copia con método para actualizar campos
  Note copyWith({
    int? id,
    String? studentName,
    double? valor,
    String? periodo,
    String? professorUsername,
    String? studentUuid,
  }) {
    return Note(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      valor: valor ?? this.valor,
      periodo: periodo ?? this.periodo,
      professorUsername: professorUsername ?? this.professorUsername,
      studentUuid: studentUuid ?? this.studentUuid,
    );
  }
  
  @override
  String toString() {
    return 'Note(id: $id, valor: $valor, periodo: $periodo)';
  }
}