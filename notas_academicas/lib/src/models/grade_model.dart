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

  // Constructor para datos recibidos al obtener todos los grados o uno por ID
  factory Grade.fromGetResponse(Map<String, dynamic> json) {
    return Grade(
      gradeId: json['gradeId'],
      grade: json['grade'] ?? '',
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
}