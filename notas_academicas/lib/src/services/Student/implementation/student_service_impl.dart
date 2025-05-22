import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/student_model.dart';
import 'package:notas_academicas/src/services/Student/interfaces/i_student_service.dart';

class StudentServiceImpl implements IStudentService {
  final ApiInterface api;
  bool _isInitialized = false;
  
  // Constructor que recibe la instancia de la API
  StudentServiceImpl(this.api);

  Future<void> initializeApi() async {
    if (_isInitialized) return; // Evita inicializaciones repetidas
    await api.initialize();
    _isInitialized = true;
  }

  @override
  Future<Student> createStudent(Student student) async {
    await initializeApi();
    
    // Convierte el estudiante a JSON usando el método específico para creación
    final requestData = student.toCreateJson();
    
    // Realiza la solicitud POST al endpoint de creación de estudiante
    final response = await api.post('/student', data: requestData);
    
    // Crea un objeto Student a partir de la respuesta
    return Student.fromGetResponse(response.data);
  }

  @override
  Future<PaginatedResponse<Student>> getAllStudents({
    int page = 0,
    int size = 10,
    String sortBy = "userEntity.username",
    String direction = "asc"
  }) async {
    await initializeApi();
    
    // Construye la URL con los parámetros de paginación
    final url = '/student?page=$page&size=$size&sortBy=$sortBy&direction=$direction';
    
    // Realiza la solicitud GET para obtener todos los estudiantes con paginación
    final response = await api.get(url);
    
    // Convierte la respuesta en un objeto PaginatedResponse<Student>
    return PaginatedResponse.fromJson(
      response.data,
      (json) => Student.fromGetResponse(json),
    );
  }

  @override
  Future<Student> getStudentById(String uuid) async {
    await initializeApi();
    
    // Realiza la solicitud GET para obtener un estudiante por ID
    final response = await api.get('/student/$uuid');
    
    // Crea un objeto Student a partir de la respuesta
    return Student.fromGetResponse(response.data);
  }

  @override
  Future<Student> updateStudent(String uuid, Student student) async {
    await initializeApi();
    
    // Convierte el estudiante a JSON usando el método específico para actualización
    final requestData = student.toUpdateJson();
    
    // Realiza la solicitud PUT para actualizar el estudiante
    final response = await api.put('/student/$uuid', data: requestData);
    
    // Crea un objeto Student a partir de la respuesta
    return Student.fromGetResponse(response.data);
  }

  @override
  Future<bool> deleteStudent(String uuid) async {
    await initializeApi();
    
    // Realiza la solicitud DELETE para eliminar un estudiante
    await api.delete('/student/$uuid');
    
    // Si no hay errores, se asume que la eliminación fue exitosa
    return true;
  }
}