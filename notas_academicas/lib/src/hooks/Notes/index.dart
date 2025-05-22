import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/notes_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:notas_academicas/src/services/Notes/note_service_impl.dart';
import 'package:notas_academicas/src/services/Notes/i_note_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de notas
final noteServiceProvider = Provider<INoteService>((ref) {
  final api = ref.watch(apiProvider);
  return NoteServiceImpl(api);
});

// Hook para obtener todas las notas
class UseGetAllNotes {
  final WidgetRef ref;
  final INoteService noteService;
  final _allNotesProvider = queryProviderFamily<PaginatedResponse<Note>>();

  UseGetAllNotes(this.ref)
      : noteService = ref.read(noteServiceProvider);

  String _getProviderKey(int page, int size, String sortBy, String direction) {
    return 'all_notes_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> fetch({
    int page = 0,
    int size = 10,
    String sortBy = 'id',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(page, size, sortBy, direction);
    final notifier = ref.read(_allNotesProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await noteService.getAllNotes(
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Note>> getState({
    int page = 0,
    int size = 10,
    String sortBy = 'id',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    return ref.watch(_allNotesProvider(key));
  }
  
  void invalidate({
    int page = 0,
    int size = 10,
    String sortBy = 'id',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    ref.invalidate(_allNotesProvider(key));
  }
}

// Hook para crear una nota
class UseCreateNote {
  final WidgetRef ref;
  final INoteService noteService;
  final _createNoteProvider = queryProviderFamily<Note>();

  UseCreateNote(this.ref) 
      : noteService = ref.read(noteServiceProvider);

  Future<void> createNote(Note note) async {
    final key = 'create_note_${DateTime.now().millisecondsSinceEpoch}';
    final notifier = ref.read(_createNoteProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await noteService.createNote(note);
    });
    
    final state = ref.read(_createNoteProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al crear nota: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas para forzar recarga de datos
      UseGetAllNotes(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Nota creada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Note> getState(String key) {
    return ref.watch(_createNoteProvider(key));
  }
}

// Hook para actualizar una nota
class UseUpdateNote {
  final WidgetRef ref;
  final INoteService noteService;
  final _updateNoteProvider = queryProviderFamily<Note>();

  UseUpdateNote(this.ref)
      : noteService = ref.read(noteServiceProvider);

  String _getProviderKey(int id) => 'update_note_$id';

  Future<void> updateNote(int id, Note note) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_updateNoteProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await noteService.updateNote(id, note);
    });
    
    final state = ref.read(_updateNoteProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al actualizar nota: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas
      UseGetAllNotes(ref).invalidate();
      UseGetNoteById(ref).invalidate(id);
      
      Fluttertoast.showToast(
        msg: "Nota actualizada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Note> getState(int id) {
    return ref.watch(_updateNoteProvider(_getProviderKey(id)));
  }
}

// Hook para eliminar una nota
class UseDeleteNote {
  final WidgetRef ref;
  final INoteService noteService;
  final _deleteNoteProvider = queryProviderFamily<bool>();

  UseDeleteNote(this.ref)
      : noteService = ref.read(noteServiceProvider);

  String _getProviderKey(int id) => 'delete_note_$id';

  Future<void> deleteNote(int id) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_deleteNoteProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await noteService.deleteNote(id);
    });
    
    final state = ref.read(_deleteNoteProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al eliminar nota: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null && state.data!) {
      // Invalidar consultas previas
      UseGetAllNotes(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Nota eliminada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<bool> getState(int id) {
    return ref.watch(_deleteNoteProvider(_getProviderKey(id)));
  }
}

// Hook para obtener una nota por ID
class UseGetNoteById {
  final WidgetRef ref;
  final INoteService noteService;
  final _noteByIdProvider = queryProviderFamily<Note>();

  UseGetNoteById(this.ref)
      : noteService = ref.read(noteServiceProvider);

  String _getProviderKey(int id) => 'note_by_id_$id';

  Future<void> fetch(int id) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_noteByIdProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await noteService.getNoteById(id);
    });
  }
  
  QueryState<Note> getState(int id) {
    return ref.watch(_noteByIdProvider(_getProviderKey(id)));
  }
  
  void invalidate(int id) {
    ref.invalidate(_noteByIdProvider(_getProviderKey(id)));
  }
}

// Hook para agregar nota a un estudiante
class UseAddNoteToStudent {
  final WidgetRef ref;
  final INoteService noteService;
  final _addNoteToStudentProvider = queryProviderFamily<Note>();

  UseAddNoteToStudent(this.ref)
      : noteService = ref.read(noteServiceProvider);

  String _getProviderKey(String studentUuid, Note note) => 
      'add_note_to_student_${studentUuid}_${note.toString()}';

  Future<void> addNoteToStudent(String studentUuid, Note note) async {
    final key = _getProviderKey(studentUuid, note);
    final notifier = ref.read(_addNoteToStudentProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await noteService.addNoteToStudent(studentUuid, note);
    });
    
    final state = ref.read(_addNoteToStudentProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al asignar nota al estudiante: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas relacionadas
      UseGetAllNotes(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Nota asignada exitosamente al estudiante",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Note> getState(String studentUuid, Note note) {
    return ref.watch(_addNoteToStudentProvider(_getProviderKey(studentUuid, note)));
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