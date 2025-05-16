import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/professor_model.dart';
import 'package:notas_academicas/src/services/Professor/interfaces/i_professor_service.dart';

class ProfessorServiceImpl implements IProfessorService {
  final ApiInterface api;
  bool _isInitialized = false;

  // Constructor que recibe la instancia de la API
  ProfessorServiceImpl(this.api);

  Future<void> initializeApi() async {
    if (_isInitialized) return; // Evita inicializaciones repetidas
    await api.initialize();
    _isInitialized = true;
  }

  @override
  Future<Professor> createProfessor(Professor professor) async {
    await initializeApi();

    // Convierte el profesor a JSON usando el método específico para creación
    final requestData = professor.toCreateJson();

    // Realiza la solicitud POST al endpoint de creación de profesor
    final response = await api.post('/professor', data: requestData);

    // Crea un objeto Professor a partir de la respuesta
    return Professor.fromGetResponse(response.data);
  }

  @override
  Future<PaginatedResponse<Professor>> getAllProfessors({
    int page = 0,
    int size = 10,
    String sortBy = "userEntity.username",
    String direction = "asc",
  }) async {
    await initializeApi();

    // Construye la URL con los parámetros de paginación
    final url =
        '/professor?page=$page&size=$size&sortBy=$sortBy&direction=$direction';

    // Realiza la solicitud GET para obtener todos los profesores con paginación
    final response = await api.get(url);

    // Convierte la respuesta en un objeto PaginatedResponse<Professor>
    return PaginatedResponse.fromJson(
      response.data,
      (json) => Professor.fromGetResponse(json),
    );
  }

  @override
  Future<Professor> getProfessorById(String uuid) async {
    await initializeApi();

    // Realiza la solicitud GET para obtener un profesor por ID
    final response = await api.get('/professor/$uuid');

    // Crea un objeto Professor a partir de la respuesta
    return Professor.fromGetResponse(response.data);
  }

  @override
  Future<Professor> updateProfessor(String uuid, Professor professor) async {
    await initializeApi();

    // Convierte el profesor a JSON usando el método específico para actualización
    final requestData = professor.toUpdateJson();

    // Realiza la solicitud PUT para actualizar el profesor
    final response = await api.put('/professor/$uuid', data: requestData);

    // Crea un objeto Professor a partir de la respuesta
    return Professor.fromGetResponse(response.data);
  }

  @override
  Future<bool> deleteProfessor(String uuid) async {
    await initializeApi();

    // Realiza la solicitud DELETE para eliminar un profesor
    await api.delete('/professor/$uuid');

    // Si no hay errores, se asume que la eliminación fue exitosa
    return true;
  }

  @override
  Future<List<AcademicLoad>> getProfessorAcademicLoad(String uuid) async {
    await initializeApi();

    // Realiza la solicitud GET para obtener la carga académica de un profesor
    final response = await api.get('/professor/$uuid/carga-academica');

    // Convierte la respuesta en una lista de objetos AcademicLoad
    final List<dynamic> academicLoadList = response.data;
    return academicLoadList.map((json) => AcademicLoad.fromJson(json)).toList();
  }

  @override
  Future<List<Professor>> getProfessorsBySpecialty(String especialidad) async {
    await initializeApi();

    // Construye la URL con el parámetro de especialidad
    final url = '/professor/especialidad?especialidad=$especialidad';

    // Realiza la solicitud GET para obtener profesores por especialidad
    final response = await api.get(url);

    // Convierte la respuesta en una lista de objetos Professor
    final List<dynamic> professorList = response.data;
    return professorList
        .map((json) => Professor.fromGetResponse(json))
        .toList();
  }

  @override
  Future<bool> checkProfessorAvailability(AvailabilityQuery query) async {
    await initializeApi();

    // Obtiene los parámetros de consulta del objeto AvailabilityQuery
    final queryParams = query.toQueryParameters();

    // Construye la URL con los parámetros de consulta
    final url = '/professor/confirmarDisponibilidad';

    // Realiza la solicitud GET para verificar la disponibilidad
    final response = await api.get(url, queryParameters: queryParams);

    // La respuesta es un booleano que indica si el profesor está disponible
    return response.data as bool;
  }
}
