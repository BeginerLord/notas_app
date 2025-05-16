import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/notes_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/services/Notes/note_service_impl.dart';
import 'package:notas_academicas/src/services/Notes/i_note_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de notas
final noteServiceProvider = Provider<INoteService>((ref) {
  final api = ref.watch(apiProvider);
  return NoteServiceImpl(api);
});

// Provider para obtener todas las notas con paginación
final getAllNotesProvider = FutureProvider.family<PaginatedResponse<Note>, Map<String, dynamic>>(
  (ref, params) async {
    final noteService = ref.read(noteServiceProvider);
    return noteService.getAllNotes(
      page: params['page'] ?? 0,
      size: params['size'] ?? 10, 
      sortBy: params['sortBy'] ?? 'id',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Provider para obtener una nota por ID
final getNoteByIdProvider = FutureProvider.family<Note, int>(
  (ref, id) async {
    final noteService = ref.read(noteServiceProvider);
    return noteService.getNoteById(id);
  },
);

// Hook para obtener todas las notas
class UseGetAllNotes {
  final WidgetRef ref;

  UseGetAllNotes(this.ref);

  Future<PaginatedResponse<Note>> getAllNotes({
    int page = 0,
    int size = 10,
    String sortBy = 'id',
    String direction = 'asc',
  }) async {
    try {
      final params = {
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'direction': direction,
      };
      
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getAllNotesProvider(params));
      
      // Esperamos el resultado
      return await ref.read(getAllNotesProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener notas: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para crear una nota
class UseCreateNote {
  final WidgetRef ref;
  final INoteService noteService;

  UseCreateNote(this.ref) 
      : noteService = ref.read(noteServiceProvider);

  Future<Note> createNote(Note note) async {
    try {
      // Ejecutar la operación de crear nota
      final createdNote = await noteService.createNote(note);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllNotesProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Nota creada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return createdNote;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al crear nota: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para actualizar una nota
class UseUpdateNote {
  final WidgetRef ref;
  final INoteService noteService;

  UseUpdateNote(this.ref)
      : noteService = ref.read(noteServiceProvider);

  Future<Note> updateNote(int id, Note note) async {
    try {
      // Ejecutar la operación de actualizar nota
      final updatedNote = await noteService.updateNote(id, note);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllNotesProvider);
      ref.invalidate(getNoteByIdProvider(id));
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Nota actualizada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return updatedNote;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al actualizar nota: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para eliminar una nota
class UseDeleteNote {
  final WidgetRef ref;
  final INoteService noteService;

  UseDeleteNote(this.ref)
      : noteService = ref.read(noteServiceProvider);

  Future<bool> deleteNote(int id) async {
    try {
      // Ejecutar la operación de eliminar nota
      final result = await noteService.deleteNote(id);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllNotesProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Nota eliminada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return result;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al eliminar nota: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener una nota por ID
class UseGetNoteById {
  final WidgetRef ref;

  UseGetNoteById(this.ref);

  Future<Note> getNoteById(int id) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getNoteByIdProvider(id));
      
      // Esperamos el resultado
      return await ref.read(getNoteByIdProvider(id).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener nota: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para agregar nota a un estudiante
class UseAddNoteToStudent {
  final WidgetRef ref;
  final INoteService noteService;

  UseAddNoteToStudent(this.ref)
      : noteService = ref.read(noteServiceProvider);

  Future<Note> addNoteToStudent(String studentUuid, Note note) async {
    try {
      // Ejecutar la operación de agregar nota a estudiante
      final addedNote = await noteService.addNoteToStudent(studentUuid, note);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllNotesProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Nota asignada exitosamente al estudiante",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return addedNote;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al asignar nota al estudiante: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Extension para facilitar el uso de hooks en widgets
extension NoteHooksExtension on BuildContext {
  WidgetRef get _ref => ProviderScope.containerOf(this) as WidgetRef;

  UseGetAllNotes get useGetAllNotes => UseGetAllNotes(_ref);
  UseCreateNote get useCreateNote => UseCreateNote(_ref);
  UseUpdateNote get useUpdateNote => UseUpdateNote(_ref);
  UseDeleteNote get useDeleteNote => UseDeleteNote(_ref);
  UseGetNoteById get useGetNoteById => UseGetNoteById(_ref);
  UseAddNoteToStudent get useAddNoteToStudent => UseAddNoteToStudent(_ref);
}