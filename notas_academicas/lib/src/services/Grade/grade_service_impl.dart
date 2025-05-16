import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/models/grade_model.dart';
import 'package:notas_academicas/src/services/Grade/i_grade_service.dart';

class GradeServiceImpl implements IGradeService {
  final ApiInterface api;
  bool _isInitialized = false;

  // Constructor que recibe la instancia de la API
  GradeServiceImpl(this.api);

  Future<void> initializeApi() async {
    if (_isInitialized) return; // Evita inicializaciones repetidas
    await api.initialize();
    _isInitialized = true;
  }

  @override
  Future<Grade> createGrade(Grade grade) async {
    await initializeApi();

    // Convierte el grado a JSON usando el método específico para creación
    final requestData = grade.toCreateJson();

    // Realiza la solicitud POST al endpoint de creación de grado
    final response = await api.post('/grade', data: requestData);

    // Crea un objeto Grade a partir de la respuesta
    return Grade.fromGetResponse(response.data);
  }

  @override
  Future<List<Grade>> getAllGrades(
    {
    int page = 0,
    int size = 10,
    String sortBy = "grade",
    String direction = "asc",
  }
  ) async {
    await initializeApi();

    // Realiza la solicitud GET para obtener todos los grados
    final response = await api.get('/grade');

    // Convierte la respuesta en una lista de objetos Grade
    final List<dynamic> gradeList = response.data;
    return gradeList.map((json) => Grade.fromGetResponse(json)).toList();
  }

  @override
  Future<Grade> getGradeById(int id) async {
    await initializeApi();

    // Realiza la solicitud GET para obtener un grado por ID
    final response = await api.get('/grade/$id');

    // Crea un objeto Grade a partir de la respuesta
    return Grade.fromGetResponse(response.data);
  }

  @override
  Future<Grade> updateGrade(int id, Grade grade) async {
    await initializeApi();

    // Convierte el grado a JSON usando el método específico para actualización
    final requestData = grade.toUpdateJson();

    // Realiza la solicitud PUT para actualizar el grado
    final response = await api.put('/grade/$id', data: requestData);

    // Crea un objeto Grade a partir de la respuesta
    return Grade.fromGetResponse(response.data);
  }

  @override
  Future<bool> deleteGrade(int id) async {
    await initializeApi();

    // Realiza la solicitud DELETE para eliminar un grado
    await api.delete('/grade/$id');

    // Si no hay errores, se asume que la eliminación fue exitosa
    return true;
  }

  @override
  Future<bool> assignSubjectsToGrade(GradeSubjectAssignment assignment) async {
    await initializeApi();

    // Convierte la asignación a JSON
    final requestData = assignment.toJson();

    // Realiza la solicitud POST para asignar materias a un grado
    await api.post('/grade/assign-subjects', data: requestData);

    // Si no hay errores, se asume que la asignación fue exitosa
    return true;
  }
}
