import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/sections_model.dart';
import 'package:notas_academicas/src/services/section/i_section_service.dart';

class SectionServiceImpl implements ISectionService {
  final ApiInterface api;
  bool _isInitialized = false;
  
  // Constructor que recibe la instancia de la API
  SectionServiceImpl(this.api);

  Future<void> initializeApi() async {
    if (_isInitialized) return; // Evita inicializaciones repetidas
    await api.initialize();
    _isInitialized = true;
  }

  @override
  Future<Section> createSection(Section section) async {
    await initializeApi();
    
    // Convierte la sección a JSON usando el método específico para creación
    final requestData = section.toCreateJson();
    
    // Realiza la solicitud POST al endpoint de creación de sección
    final response = await api.post('/section', data: requestData);
    
    // Crea un objeto Section a partir de la respuesta
    return Section.fromGetResponse(response.data);
  }

  @override
  Future<PaginatedResponse<Section>> getAllSections({
    int page = 0,
    int size = 10,
    String sortBy = "sectionName",
    String direction = "asc"
  }) async {
    await initializeApi();
    
    // Construye la URL con los parámetros de paginación
    final url = '/section?page=$page&size=$size&sortBy=$sortBy&direction=$direction';
    
    // Realiza la solicitud GET para obtener todas las secciones con paginación
    final response = await api.get(url);
    
    // Convierte la respuesta en un objeto PaginatedResponse<Section>
    return PaginatedResponse.fromJson(
      response.data,
      (json) => Section.fromGetResponse(json),
    );
  }

  @override
  Future<Section> getSectionById(int id) async {
    await initializeApi();
    
    // Realiza la solicitud GET para obtener una sección por ID
    final response = await api.get('/section/$id');
    
    // Crea un objeto Section a partir de la respuesta
    return Section.fromGetResponse(response.data);
  }

  @override
  Future<Section> updateSection(int id, Section section) async {
    await initializeApi();
    
    // Convierte la sección a JSON usando el método específico para actualización
    final requestData = section.toUpdateJson();
    
    // Realiza la solicitud PUT para actualizar la sección
    final response = await api.put('/section/$id', data: requestData);
    
    // Crea un objeto Section a partir de la respuesta
    return Section.fromGetResponse(response.data);
  }

  @override
  Future<bool> deleteSection(int id) async {
    await initializeApi();
    
    // Realiza la solicitud DELETE para eliminar una sección
    await api.delete('/section/$id');
    
    // Si no hay errores, se asume que la eliminación fue exitosa
    return true;
  }

  @override
  Future<PaginatedResponse<Section>> getSectionsByGradeId({
    required int gradeId,
    int page = 0,
    int size = 10,
    String sortBy = "sectionName",
    String direction = "asc"
  }) async {
    await initializeApi();
    
    // Construye la URL con los parámetros de paginación y el ID del grado
    final url = '/section/por-grado?gradeId=$gradeId&page=$page&size=$size&sortBy=$sortBy&direction=$direction';
    
    // Realiza la solicitud GET para obtener secciones por grado
    final response = await api.get(url);
    
    // Convierte la respuesta en un objeto PaginatedResponse<Section>
    return PaginatedResponse.fromJson(
      response.data,
      (json) => Section.fromGetResponse(json),
    );
  }
}