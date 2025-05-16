import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/student_model.dart';

abstract class IStudentService {
  Future<Student> createStudent(Student student);

  Future<PaginatedResponse<Student>> getAllStudents({
    int page = 0,
    int size = 10,
    String sortBy = "userEntity.username",
    String direction = "asc"
  });


  Future<Student> getStudentById(String uuid);

  Future<Student> updateStudent(String uuid, Student student);

  Future<bool> deleteStudent(String uuid);
}
