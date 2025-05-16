class Subject {
  final int? id;
  final String subjectName;
  final String? profesorNombre;
  final String? profesorEmail;
  final String? especialidad;
  final List<String>? grados;
  final String? professorUuid;
  final List<int>? gradeIds;

  Subject({
    this.id,
    required this.subjectName,
    this.profesorNombre,
    this.profesorEmail,
    this.especialidad,
    this.grados,
    this.professorUuid,
    this.gradeIds,
  });

  // Constructor para crear una nueva materia
  factory Subject.create({
    required String subjectName,
    required String professorUuid,
    required List<int> gradeIds,
  }) {
    return Subject(
      subjectName: subjectName,
      professorUuid: professorUuid,
      gradeIds: gradeIds,
    );
  }

  // Constructor para datos recibidos al obtener todas las materias o una por ID
  factory Subject.fromGetResponse(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      subjectName: json['subjectName'],
      profesorNombre: json['profesorNombre'],
      profesorEmail: json['profesorEmail'],
      especialidad: json['especialidad'],
      grados: json['grados'] != null 
          ? List<String>.from(json['grados']) 
          : null,
    );
  }

  // Convertir a JSON para crear una materia
  Map<String, dynamic> toCreateJson() {
    return {
      'subjectName': subjectName,
      'professorUuid': professorUuid,
      'gradeIds': gradeIds,
    };
  }

  // Convertir a JSON para actualizar una materia
  Map<String, dynamic> toUpdateJson() {
    return {
      'subjectName': subjectName,
      'professorUuid': professorUuid,
      'gradeIds': gradeIds,
    };
  }

  // Copia con método para actualizar campos
  Subject copyWith({
    int? id,
    String? subjectName,
    String? profesorNombre,
    String? profesorEmail,
    String? especialidad,
    List<String>? grados,
    String? professorUuid,
    List<int>? gradeIds,
  }) {
    return Subject(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      profesorNombre: profesorNombre ?? this.profesorNombre,
      profesorEmail: profesorEmail ?? this.profesorEmail,
      especialidad: especialidad ?? this.especialidad,
      grados: grados ?? this.grados,
      professorUuid: professorUuid ?? this.professorUuid,
      gradeIds: gradeIds ?? this.gradeIds,
    );
  }
}
