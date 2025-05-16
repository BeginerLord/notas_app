import 'package:notas_academicas/src/models/grade_model.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';

abstract class IGradeService {
  Future<Grade> createGrade(Grade grade);

  Future<PaginatedResponse<Grade>> getAllGrades({
    int page = 0,
    int size = 10,
    String sortBy = "grade",
    String direction = "asc",
  });

  Future<Grade> getGradeById(int id);

  Future<Grade> updateGrade(int id, Grade grade);

  Future<bool> deleteGrade(int id);

  Future<bool> assignSubjectsToGrade(GradeSubjectAssignment assignment);
}
