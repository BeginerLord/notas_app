class Grade {
  final int? gradeId;
  final String grade;

  Grade({
    this.gradeId,
    required this.grade,
  });

  // Constructor para crear un nuevo grado
  factory Grade.create({
    required String grade,
  }) {
    return Grade(
      grade: grade,
    );
  }

  // Constructor mejorado que acepta tanto Map como String
  factory Grade.fromGetResponse(dynamic json) {
    // Si la respuesta es un String (mensaje de éxito), devolvemos un grado con datos mínimos
    if (json is String) {
      return Grade(
        gradeId: null,
        grade: 'Nuevo Grado', // Valor predeterminado
      );
    }
    
    // Si la respuesta es un Map (JSON), procesamos normalmente
    if (json is Map<String, dynamic>) {
      return Grade(
        gradeId: json['gradeId'] ?? json['id'],
        grade: json['grade'] ?? '',
      );
    }
    
    // Si no es ni String ni Map, lanzamos una excepción más descriptiva
    throw FormatException(
      'Se esperaba un objeto JSON o un string, pero se recibió: ${json.runtimeType}',
    );
  }

  // Convertir a JSON para crear un grado
  Map<String, dynamic> toCreateJson() {
    return {
      'grade': grade,
    };
  }

  // Convertir a JSON para actualizar un grado
  Map<String, dynamic> toUpdateJson() {
    return {
      'grade': grade,
    };
  }

  // Copia con método para actualizar campos
  Grade copyWith({
    int? gradeId,
    String? grade,
  }) {
    return Grade(
      gradeId: gradeId ?? this.gradeId,
      grade: grade ?? this.grade,
    );
  }
}

// Modelo para asignar materias a un grado
class GradeSubjectAssignment {
  final int gradeId;
  final List<int> subjectIds;

  GradeSubjectAssignment({
    required this.gradeId,
    required this.subjectIds,
  });

  // Convertir a JSON para asignar materias a grado
  Map<String, dynamic> toJson() {
    return {
      'gradeId': gradeId,
      'subjectIds': subjectIds,
    };
  }

  // Constructor desde JSON
  factory GradeSubjectAssignment.fromJson(Map<String, dynamic> json) {
    return GradeSubjectAssignment(
      gradeId: json['gradeId'] ?? 0,
      subjectIds: (json['subjectIds'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }
  
  @override
  String toString() {
    return 'GradeId:$gradeId-SubjectIds:${subjectIds.join(",")}';
  }
}