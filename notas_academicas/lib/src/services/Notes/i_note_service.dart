import 'package:notas_academicas/src/models/notes_model.dart';

abstract class INoteService {
  Future<Note> createNote(Note note);

  Future<List<Note>> getAllNotes({
    int page = 0,
    int size = 10,
    String sortBy = "id",
    String direction = "asc",
  });

  Future<Note> getNoteById(int id);

  Future<Note> updateNote(int id, Note note);

  Future<bool> deleteNote(int id);

  Future<Note> addNoteToStudent(String studentUuid, Note note);
}
