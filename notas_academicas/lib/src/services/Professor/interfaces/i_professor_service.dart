import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/professor_model.dart';

abstract class IProfessorService {
  Future<Professor> createProfessor(Professor professor);

  Future<PaginatedResponse<Professor>> getAllProfessors({
    int page = 0,
    int size = 10,
    String sortBy = "userEntity.username",
    String direction = "asc",
  });

  Future<Professor> getProfessorById(String uuid);

  Future<Professor> updateProfessor(String uuid, Professor professor);

  Future<bool> deleteProfessor(String uuid);

  Future<List<AcademicLoad>> getProfessorAcademicLoad(String uuid);

  Future<List<Professor>> getProfessorsBySpecialty(String especialidad);

  Future<bool> checkProfessorAvailability(AvailabilityQuery query);
}
