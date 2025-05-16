class Section {
  final int? id;
  final String sectionName;
  final String? grade;
  final int? studentCount;
  final List<String>? subjectNames;
  final int? gradeId;

  Section({
    this.id,
    required this.sectionName,
    this.grade,
    this.studentCount,
    this.subjectNames,
    this.gradeId,
  });

  // Constructor para crear una nueva sección
  factory Section.create({
    required String sectionName,
    required int gradeId,
  }) {
    return Section(
      sectionName: sectionName,
      gradeId: gradeId,
    );
  }

  // Constructor para datos recibidos al obtener todas las secciones o una por ID
  factory Section.fromGetResponse(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      sectionName: json['sectionName'] ?? '',
      grade: json['grade'],
      studentCount: json['studentCount'],
      subjectNames: json['subjectNames'] != null
          ? List<String>.from(json['subjectNames'])
          : null,
    );
  }

  // Convertir a JSON para crear una sección
  Map<String, dynamic> toCreateJson() {
    return {
      'sectionName': sectionName,
      'gradeId': gradeId,
    };
  }

  // Convertir a JSON para actualizar una sección
  Map<String, dynamic> toUpdateJson() {
    return {
      'sectionName': sectionName,
      'gradeId': gradeId,
    };
  }

  // Copia con método para actualizar campos
  Section copyWith({
    int? id,
    String? sectionName,
    String? grade,
    int? studentCount,
    List<String>? subjectNames,
    int? gradeId,
  }) {
    return Section(
      id: id ?? this.id,
      sectionName: sectionName ?? this.sectionName,
      grade: grade ?? this.grade,
      studentCount: studentCount ?? this.studentCount,
      subjectNames: subjectNames ?? this.subjectNames,
      gradeId: gradeId ?? this.gradeId,
    );
  }
}