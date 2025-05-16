import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/models/notes_model.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/services/Notes/i_note_service.dart';

class NoteServiceImpl implements INoteService {
  final ApiInterface api;
  bool _isInitialized = false;

  // Constructor que recibe la instancia de la API
  NoteServiceImpl(this.api);

  Future<void> initializeApi() async {
    if (_isInitialized) return; // Evita inicializaciones repetidas
    await api.initialize();
    _isInitialized = true;
  }

  @override
  Future<Note> createNote(Note note) async {
    await initializeApi();

    // Convierte la nota a JSON usando el método específico para creación
    final requestData = note.toCreateJson();

    // Realiza la solicitud POST al endpoint de creación de nota
    final response = await api.post('/note', data: requestData);

    // Crea un objeto Note a partir de la respuesta
    return Note.fromGetResponse(response.data);
  }

  @override
  Future<PaginatedResponse<Note>> getAllNotes({
    int page = 0,
    int size = 10,
    String sortBy = "id",
    String direction = "asc",
  }) async {
    await initializeApi();

    // Construye la URL con los parámetros de paginación
    final url =
        '/note?page=$page&size=$size&sortBy=$sortBy&direction=$direction';

    // Realiza la solicitud GET para obtener todas las notas con paginación
    final response = await api.get(url);

    // Convierte la respuesta en un objeto PaginatedResponse<Note>
    return PaginatedResponse.fromJson(
      response.data,
      (json) => Note.fromGetResponse(json),
    );
  }

  @override
  Future<Note> updateNote(int id, Note note) async {
    await initializeApi();

    // Convierte la nota a JSON usando el método específico para actualización
    final requestData = note.toUpdateJson();

    // Realiza la solicitud PUT para actualizar la nota
    final response = await api.put('/note/$id', data: requestData);

    // Crea un objeto Note a partir de la respuesta
    return Note.fromGetResponse(response.data);
  }

  @override
  Future<bool> deleteNote(int id) async {
    await initializeApi();

    // Realiza la solicitud DELETE para eliminar una nota
    await api.delete('/note/$id');

    // Si no hay errores, se asume que la eliminación fue exitosa
    return true;
  }

  @override
  Future<Note> addNoteToStudent(String studentUuid, Note note) async {
    await initializeApi();

    // Convierte la nota a JSON usando el método específico para actualización
    final requestData = note.toUpdateJson();

    // Realiza la solicitud PUT para agregar una nota a un estudiante
    final response = await api.put('/note/add/$studentUuid', data: requestData);

    // Crea un objeto Note a partir de la respuesta
    return Note.fromGetResponse(response.data);
  }

  @override
  Future<Note> getNoteById(int id) async {
    await initializeApi();

    // Realiza la solicitud GET para obtener una nota por su ID
    final response = await api.get('/note/$id');

    // Crea un objeto Note a partir de la respuesta
    return Note.fromGetResponse(response.data);
  }
}
