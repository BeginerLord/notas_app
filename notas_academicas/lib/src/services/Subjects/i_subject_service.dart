import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/subjects_model.dart';

abstract class ISubjectService {
  // Crear una nueva materia
  Future<Subject> createSubject(Subject subject);

  // Obtener todas las materias con paginación
  Future<PaginatedResponse<Subject>> getAllSubjects({
    int page = 0,
    int size = 10,
    String sortBy = "subjectName",
    String direction = "asc"
  });

  // Buscar materia por ID
  Future<Subject> getSubjectById(int id);

  // Actualizar materia por ID
  Future<Subject> updateSubject(int id, Subject subject);

  // Eliminar materia por ID
  Future<bool> deleteSubject(int id);

  // Buscar materias por profesor ID con paginación
  Future<PaginatedResponse<Subject>> getSubjectsByProfessor({
    required int professorId,
    int page = 0,
    int size = 10,
    String sortBy = "subjectName",
    String direction = "asc"
  });

  // Buscar materias por nombre (coincidencia parcial) con paginación
  Future<PaginatedResponse<Subject>> searchSubjectsByName({
    required String subjectName,
    int page = 0,
    int size = 10,
    String sortBy = "subjectName",
    String direction = "asc"
  });
}