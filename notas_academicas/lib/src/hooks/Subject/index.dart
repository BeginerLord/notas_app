import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/subjects_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:notas_academicas/src/services/Subjects/subject_service_impl.dart';
import 'package:notas_academicas/src/services/Subjects/i_subject_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de materias
final subjectServiceProvider = Provider<ISubjectService>((ref) {
  final api = ref.watch(apiProvider);
  return SubjectServiceImpl(api);
});

// Hook para obtener todas las materias
class UseGetAllSubjects {
  final WidgetRef ref;
  final ISubjectService subjectService;
  final _allSubjectsProvider = queryProviderFamily<PaginatedResponse<Subject>>();

  UseGetAllSubjects(this.ref)
      : subjectService = ref.read(subjectServiceProvider);

  String _getProviderKey(int page, int size, String sortBy, String direction) {
    return 'all_subjects_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> fetch({
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(page, size, sortBy, direction);
    final notifier = ref.read(_allSubjectsProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await subjectService.getAllSubjects(
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Subject>> getState({
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    return ref.watch(_allSubjectsProvider(key));
  }
  
  void invalidate({
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    ref.invalidate(_allSubjectsProvider(key));
  }
}

// Hook para crear una materia
class UseCreateSubject {
  final WidgetRef ref;
  final ISubjectService subjectService;
  final _createSubjectProvider = queryProviderFamily<Subject>();

  UseCreateSubject(this.ref) 
      : subjectService = ref.read(subjectServiceProvider);

  Future<void> createSubject(Subject subject) async {
    final key = 'create_subject_${DateTime.now().millisecondsSinceEpoch}';
    final notifier = ref.read(_createSubjectProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await subjectService.createSubject(subject);
    });
    
    final state = ref.read(_createSubjectProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al crear materia: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas para forzar recarga de datos
      UseGetAllSubjects(ref).invalidate();
      
      // Si conocemos el professorUuid, también invalidamos las materias de ese profesor
      if (subject.professorUuid != null) {
        UseGetSubjectsByProfessor(ref).invalidate(professorId: int.tryParse(subject.professorUuid!) ?? 0);
      }
      
      Fluttertoast.showToast(
        msg: "Materia creada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Subject> getState(String key) {
    return ref.watch(_createSubjectProvider(key));
  }
}

// Hook para actualizar una materia
class UseUpdateSubject {
  final WidgetRef ref;
  final ISubjectService subjectService;
  final _updateSubjectProvider = queryProviderFamily<Subject>();

  UseUpdateSubject(this.ref)
      : subjectService = ref.read(subjectServiceProvider);

  String _getProviderKey(int id) => 'update_subject_$id';

  Future<void> updateSubject(int id, Subject subject) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_updateSubjectProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await subjectService.updateSubject(id, subject);
    });
    
    final state = ref.read(_updateSubjectProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al actualizar materia: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas
      UseGetAllSubjects(ref).invalidate();
      UseGetSubjectById(ref).invalidate(id);
      
      // Si conocemos el professorUuid, también invalidamos las materias de ese profesor
      if (subject.professorUuid != null) {
        UseGetSubjectsByProfessor(ref).invalidate(professorId: int.tryParse(subject.professorUuid!) ?? 0);
      }
      
      Fluttertoast.showToast(
        msg: "Materia actualizada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Subject> getState(int id) {
    return ref.watch(_updateSubjectProvider(_getProviderKey(id)));
  }
}

// Hook para eliminar una materia
class UseDeleteSubject {
  final WidgetRef ref;
  final ISubjectService subjectService;
  final _deleteSubjectProvider = queryProviderFamily<bool>();

  UseDeleteSubject(this.ref)
      : subjectService = ref.read(subjectServiceProvider);

  String _getProviderKey(int id) => 'delete_subject_$id';

  Future<void> deleteSubject(int id) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_deleteSubjectProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await subjectService.deleteSubject(id);
    });
    
    final state = ref.read(_deleteSubjectProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al eliminar materia: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null && state.data!) {
      // Invalidar consultas previas
      UseGetAllSubjects(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Materia eliminada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<bool> getState(int id) {
    return ref.watch(_deleteSubjectProvider(_getProviderKey(id)));
  }
}

// Hook para obtener una materia por ID
class UseGetSubjectById {
  final WidgetRef ref;
  final ISubjectService subjectService;
  final _subjectByIdProvider = queryProviderFamily<Subject>();

  UseGetSubjectById(this.ref)
      : subjectService = ref.read(subjectServiceProvider);

  String _getProviderKey(int id) => 'subject_by_id_$id';

  Future<void> fetch(int id) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_subjectByIdProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await subjectService.getSubjectById(id);
    });
  }
  
  QueryState<Subject> getState(int id) {
    return ref.watch(_subjectByIdProvider(_getProviderKey(id)));
  }
  
  void invalidate(int id) {
    ref.invalidate(_subjectByIdProvider(_getProviderKey(id)));
  }
}

// Hook para obtener materias por profesor
class UseGetSubjectsByProfessor {
  final WidgetRef ref;
  final ISubjectService subjectService;
  final _subjectsByProfessorProvider = queryProviderFamily<PaginatedResponse<Subject>>();

  UseGetSubjectsByProfessor(this.ref)
      : subjectService = ref.read(subjectServiceProvider);

  String _getProviderKey({
    required int professorId,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) {
    return 'subjects_by_professor_${professorId}_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> fetch({
    required int professorId,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(
      professorId: professorId,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    final notifier = ref.read(_subjectsByProfessorProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await subjectService.getSubjectsByProfessor(
        professorId: professorId,
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Subject>> getState({
    required int professorId,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(
      professorId: professorId,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    return ref.watch(_subjectsByProfessorProvider(key));
  }
  
  void invalidate({
    required int professorId,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(
      professorId: professorId,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    ref.invalidate(_subjectsByProfessorProvider(key));
  }
}

// Hook para buscar materias por nombre
class UseSearchSubjectsByName {
  final WidgetRef ref;
  final ISubjectService subjectService;
  final _searchSubjectsProvider = queryProviderFamily<PaginatedResponse<Subject>>();

  UseSearchSubjectsByName(this.ref)
      : subjectService = ref.read(subjectServiceProvider);

  String _getProviderKey({
    required String subjectName,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) {
    return 'search_subjects_${subjectName}_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> search({
    required String subjectName,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(
      subjectName: subjectName,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    final notifier = ref.read(_searchSubjectsProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await subjectService.searchSubjectsByName(
        subjectName: subjectName,
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Subject>> getState({
    required String subjectName,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(
      subjectName: subjectName,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    return ref.watch(_searchSubjectsProvider(key));
  }
  
  void invalidate({
    required String subjectName,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(
      subjectName: subjectName,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    ref.invalidate(_searchSubjectsProvider(key));
  }
}

// Extension para facilitar el uso de hooks en widgets
extension SubjectHooksExtension on BuildContext {
  WidgetRef get _ref => ProviderScope.containerOf(this) as WidgetRef;

  UseGetAllSubjects get useGetAllSubjects => UseGetAllSubjects(_ref);
  UseCreateSubject get useCreateSubject => UseCreateSubject(_ref);
  UseUpdateSubject get useUpdateSubject => UseUpdateSubject(_ref);
  UseDeleteSubject get useDeleteSubject => UseDeleteSubject(_ref);
  UseGetSubjectById get useGetSubjectById => UseGetSubjectById(_ref);
  UseGetSubjectsByProfessor get useGetSubjectsByProfessor => UseGetSubjectsByProfessor(_ref);
  UseSearchSubjectsByName get useSearchSubjectsByName => UseSearchSubjectsByName(_ref);
}