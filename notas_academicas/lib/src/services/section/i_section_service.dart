import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/sections_model.dart';

abstract class ISectionService {
  Future<Section> createSection(Section section);

  Future<PaginatedResponse<Section>> getAllSections({
    int page = 0,
    int size = 10,
    String sortBy = "sectionName",
    String direction = "asc",
  });

  Future<Section> getSectionById(int id);

  Future<Section> updateSection(int id, Section section);

  Future<bool> deleteSection(int id);

  Future<PaginatedResponse<Section>> getSectionsByGradeId({
    required int gradeId,
    int page = 0,
    int size = 10,
    String sortBy = "sectionName",
    String direction = "asc",
  });
}
