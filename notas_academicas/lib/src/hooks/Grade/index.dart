import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/grade_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:notas_academicas/src/services/Grade/grade_service_impl.dart';
import 'package:notas_academicas/src/services/Grade/i_grade_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de grados
final gradeServiceProvider = Provider<IGradeService>((ref) {
  final api = ref.watch(apiProvider);
  return GradeServiceImpl(api);
});

// Hook para obtener todos los grados
class UseGetAllGrades {
  final WidgetRef ref;
  final IGradeService gradeService;
  final _allGradesProvider = queryProviderFamily<PaginatedResponse<Grade>>();

  UseGetAllGrades(this.ref)
      : gradeService = ref.read(gradeServiceProvider);

  String _getProviderKey(int page, int size, String sortBy, String direction) {
    return 'all_grades_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> fetch({
    int page = 0,
    int size = 10,
    String sortBy = 'grade',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(page, size, sortBy, direction);
    final notifier = ref.read(_allGradesProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await gradeService.getAllGrades(
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Grade>> getState({
    int page = 0,
    int size = 10,
    String sortBy = 'grade',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    return ref.watch(_allGradesProvider(key));
  }
  
  void invalidate({
    int page = 0,
    int size = 10,
    String sortBy = 'grade',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    ref.invalidate(_allGradesProvider(key));
  }
}

// Hook para crear un grado
class UseCreateGrade {
  final WidgetRef ref;
  final IGradeService gradeService;
  final _createGradeProvider = queryProviderFamily<Grade>();

  UseCreateGrade(this.ref) 
      : gradeService = ref.read(gradeServiceProvider);

  Future<void> createGrade(Grade grade) async {
    final key = 'create_grade_${DateTime.now().millisecondsSinceEpoch}';
    final notifier = ref.read(_createGradeProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await gradeService.createGrade(grade);
    });
    
    final state = ref.read(_createGradeProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al crear grado: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas para forzar recarga de datos
      UseGetAllGrades(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Grado creado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Grade> getState(String key) {
    return ref.watch(_createGradeProvider(key));
  }
}

// Hook para actualizar un grado
class UseUpdateGrade {
  final WidgetRef ref;
  final IGradeService gradeService;
  final _updateGradeProvider = queryProviderFamily<Grade>();

  UseUpdateGrade(this.ref)
      : gradeService = ref.read(gradeServiceProvider);

  String _getProviderKey(int id) => 'update_grade_$id';

  Future<void> updateGrade(int id, Grade grade) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_updateGradeProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await gradeService.updateGrade(id, grade);
    });
    
    final state = ref.read(_updateGradeProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al actualizar grado: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas
      UseGetAllGrades(ref).invalidate();
      UseGetGradeById(ref).invalidate(id);
      
      Fluttertoast.showToast(
        msg: "Grado actualizado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Grade> getState(int id) {
    return ref.watch(_updateGradeProvider(_getProviderKey(id)));
  }
}

// Hook para eliminar un grado
class UseDeleteGrade {
  final WidgetRef ref;
  final IGradeService gradeService;
  final _deleteGradeProvider = queryProviderFamily<bool>();

  UseDeleteGrade(this.ref)
      : gradeService = ref.read(gradeServiceProvider);

  String _getProviderKey(int id) => 'delete_grade_$id';

  Future<void> deleteGrade(int id) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_deleteGradeProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await gradeService.deleteGrade(id);
    });
    
    final state = ref.read(_deleteGradeProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al eliminar grado: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null && state.data!) {
      // Invalidar consultas previas
      UseGetAllGrades(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Grado eliminado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<bool> getState(int id) {
    return ref.watch(_deleteGradeProvider(_getProviderKey(id)));
  }
}

// Hook para obtener un grado por ID
class UseGetGradeById {
  final WidgetRef ref;
  final IGradeService gradeService;
  final _gradeByIdProvider = queryProviderFamily<Grade>();

  UseGetGradeById(this.ref)
      : gradeService = ref.read(gradeServiceProvider);

  String _getProviderKey(int id) => 'grade_by_id_$id';

  Future<void> fetch(int id) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_gradeByIdProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await gradeService.getGradeById(id);
    });
  }
  
  QueryState<Grade> getState(int id) {
    return ref.watch(_gradeByIdProvider(_getProviderKey(id)));
  }
  
  void invalidate(int id) {
    ref.invalidate(_gradeByIdProvider(_getProviderKey(id)));
  }
}

// Hook para asignar materias a un grado
class UseAssignSubjectsToGrade {
  final WidgetRef ref;
  final IGradeService gradeService;
  final _assignSubjectsProvider = queryProviderFamily<bool>();

  UseAssignSubjectsToGrade(this.ref)
      : gradeService = ref.read(gradeServiceProvider);

  String _getProviderKey(GradeSubjectAssignment assignment) => 
      'assign_subjects_to_grade_${assignment.toString()}';

  Future<void> assignSubjectsToGrade(GradeSubjectAssignment assignment) async {
    final key = _getProviderKey(assignment);
    final notifier = ref.read(_assignSubjectsProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await gradeService.assignSubjectsToGrade(assignment);
    });
    
    final state = ref.read(_assignSubjectsProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al asignar materias: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null && state.data!) {
      // Invalidar consultas relacionadas
      UseGetAllGrades(ref).invalidate();
      UseGetGradeById(ref).invalidate(assignment.gradeId);
      
      Fluttertoast.showToast(
        msg: "Materias asignadas exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<bool> getState(GradeSubjectAssignment assignment) {
    return ref.watch(_assignSubjectsProvider(_getProviderKey(assignment)));
  }
}

// Extension para facilitar el uso de hooks en widgets
extension GradeHooksExtension on BuildContext {
  WidgetRef get _ref => ProviderScope.containerOf(this) as WidgetRef;

  UseGetAllGrades get useGetAllGrades => UseGetAllGrades(_ref);
  UseCreateGrade get useCreateGrade => UseCreateGrade(_ref);
  UseUpdateGrade get useUpdateGrade => UseUpdateGrade(_ref);
  UseDeleteGrade get useDeleteGrade => UseDeleteGrade(_ref);
  UseGetGradeById get useGetGradeById => UseGetGradeById(_ref);
  UseAssignSubjectsToGrade get useAssignSubjectsToGrade => UseAssignSubjectsToGrade(_ref);
}