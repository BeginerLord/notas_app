import 'package:notas_academicas/src/models/grade_model.dart';

abstract class IGradeService {
  Future<Grade> createGrade(Grade grade);

  Future<List<Grade>> getAllGrades();

  Future<Grade> getGradeById(int id);

  Future<Grade> updateGrade(int id, Grade grade);

  Future<bool> deleteGrade(int id);

  Future<bool> assignSubjectsToGrade(GradeSubjectAssignment assignment);
}
