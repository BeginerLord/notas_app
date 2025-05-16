class Schedule {
  final int? id;
  final String dia;
  final String horaInicio;
  final String horaFin;
  final String? sectionName;
  final String? subjectName;
  final String? grade;
  final String? professorUsername;
  final int? sectionId;
  final int? subjectId;
  final bool? confirmado;

  Schedule({
    this.id,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    this.sectionName,
    this.subjectName,
    this.grade,
    this.professorUsername,
    this.sectionId,
    this.subjectId,
    this.confirmado,
  });

  // Constructor para asignar un nuevo horario a un profesor
  factory Schedule.forAssignment({
    required String dia,
    required String horaInicio,
    required String horaFin,
    required int sectionId,
    required int subjectId,
  }) {
    return Schedule(
      dia: dia,
      horaInicio: horaInicio, 
      horaFin: horaFin,
      sectionId: sectionId,
      subjectId: subjectId,
    );
  }

  // Constructor para datos recibidos al obtener horarios de profesor o estudiante
  factory Schedule.fromGetResponse(Map<String, dynamic> json) {
    return Schedule(
      dia: json['dia'] ?? '',
      horaInicio: json['horaInicio'] ?? '',
      horaFin: json['horaFin'] ?? '',
      sectionName: json['sectionName'],
      subjectName: json['subjectName'],
      grade: json['grade'],
      professorUsername: json['professorUsername'],
      id: json['id'],
      confirmado: json['confirmado'],
    );
  }

  // Convertir a JSON para asignar horario a profesor
  Map<String, dynamic> toAssignScheduleJson() {
    return {
      'dia': dia,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'sectionId': sectionId,
      'subjectId': subjectId,
    };
  }

  // Copia con método para actualizar campos
  Schedule copyWith({
    int? id,
    String? dia,
    String? horaInicio,
    String? horaFin,
    String? sectionName,
    String? subjectName,
    String? grade,
    String? professorUsername,
    int? sectionId,
    int? subjectId,
    bool? confirmado,
  }) {
    return Schedule(
      id: id ?? this.id,
      dia: dia ?? this.dia,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      sectionName: sectionName ?? this.sectionName,
      subjectName: subjectName ?? this.subjectName,
      grade: grade ?? this.grade,
      professorUsername: professorUsername ?? this.professorUsername,
      sectionId: sectionId ?? this.sectionId,
      subjectId: subjectId ?? this.subjectId,
      confirmado: confirmado ?? this.confirmado,
    );
  }
}

// Modelo para confirmar un horario
class ScheduleConfirmation {
  final String profesorUuid;
  final int horarioId;

  ScheduleConfirmation({
    required this.profesorUuid,
    required this.horarioId,
  });

  Map<String, dynamic> toJson() {
    return {
      'profesorUuid': profesorUuid,
      'horarioId': horarioId,
    };
  }
}