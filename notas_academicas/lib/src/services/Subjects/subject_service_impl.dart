import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/subjects_model.dart';
import 'package:notas_academicas/src/services/Subjects/i_subject_service.dart';

class SubjectServiceImpl implements ISubjectService {
  final ApiInterface api;
  bool _isInitialized = false;
  
  // Constructor que recibe la instancia de la API
  SubjectServiceImpl(this.api);

  Future<void> initializeApi() async {
    if (_isInitialized) return; // Evita inicializaciones repetidas
    await api.initialize();
    _isInitialized = true;
  }

  @override
  Future<Subject> createSubject(Subject subject) async {
    await initializeApi();
    
    // Convierte la materia a JSON usando el método específico para creación
    final requestData = subject.toCreateJson();
    
    // Realiza la solicitud POST al endpoint de creación de materia
    final response = await api.post('/subject', data: requestData);
    
    // Crea un objeto Subject a partir de la respuesta
    return Subject.fromGetResponse(response.data);
  }

  @override
  Future<PaginatedResponse<Subject>> getAllSubjects({
    int page = 0,
    int size = 10,
    String sortBy = "subjectName",
    String direction = "asc"
  }) async {
    await initializeApi();
    
    // Construye la URL con los parámetros de paginación
    final url = '/subject?page=$page&size=$size&sortBy=$sortBy&direction=$direction';
    
    // Realiza la solicitud GET para obtener todas las materias con paginación
    final response = await api.get(url);
    
    // Convierte la respuesta en un objeto PaginatedResponse<Subject>
    return PaginatedResponse.fromJson(
      response.data,
      (json) => Subject.fromGetResponse(json)
    );
  }

  @override
  Future<Subject> getSubjectById(int id) async {
    await initializeApi();
    
    // Realiza la solicitud GET para obtener una materia por ID
    final response = await api.get('/subject/$id');
    
    // Crea un objeto Subject a partir de la respuesta
    return Subject.fromGetResponse(response.data);
  }

  @override
  Future<Subject> updateSubject(int id, Subject subject) async {
    await initializeApi();
    
    // Convierte la materia a JSON usando el método específico para actualización
    final requestData = subject.toUpdateJson();
    
    // Realiza la solicitud PUT para actualizar la materia
    final response = await api.put('/subject/$id', data: requestData);
    
    // Crea un objeto Subject a partir de la respuesta
    return Subject.fromGetResponse(response.data);
  }

  @override
  Future<bool> deleteSubject(int id) async {
    await initializeApi();
    
    // Realiza la solicitud DELETE para eliminar una materia
    await api.delete('/subject/$id');
    
    // Si no hay errores, se asume que la eliminación fue exitosa
    return true;
  }

  @override
  Future<PaginatedResponse<Subject>> getSubjectsByProfessor({
    required int professorId,
    int page = 0,
    int size = 10,
    String sortBy = "subjectName",
    String direction = "asc"
  }) async {
    await initializeApi();
    
    // Construye la URL con los parámetros de paginación y el ID del profesor
    final url = '/professor?professorId=$professorId&page=$page&size=$size&sortBy=$sortBy&direction=$direction';
    
    // Realiza la solicitud GET para obtener materias por profesor
    final response = await api.get(url);
    
    // Convierte la respuesta en un objeto PaginatedResponse<Subject>
    return PaginatedResponse.fromJson(
      response.data,
      (json) => Subject.fromGetResponse(json)
    );
  }

  @override
  Future<PaginatedResponse<Subject>> searchSubjectsByName({
    required String subjectName,
    int page = 0,
    int size = 10,
    String sortBy = "subjectName",
    String direction = "asc"
  }) async {
    await initializeApi();
    
    // Construye la URL con los parámetros de paginación y el nombre de la materia
    final url = '/subject/buscar?subjectName=$subjectName&page=$page&size=$size&sortBy=$sortBy&direction=$direction';
    
    // Realiza la solicitud GET para buscar materias por nombre
    final response = await api.get(url);
    
    // Convierte la respuesta en un objeto PaginatedResponse<Subject>
    return PaginatedResponse.fromJson(
      response.data,
      (json) => Subject.fromGetResponse(json)
    );
  }
}