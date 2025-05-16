import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/grade_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/services/Grade/grade_service_impl.dart';
import 'package:notas_academicas/src/services/Grade/i_grade_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de grados
final gradeServiceProvider = Provider<IGradeService>((ref) {
  final api = ref.watch(apiProvider);
  return GradeServiceImpl(api);
});

// Provider para obtener todos los grados con paginación
final getAllGradesProvider = FutureProvider.family<PaginatedResponse<Grade>, Map<String, dynamic>>(
  (ref, params) async {
    final gradeService = ref.read(gradeServiceProvider);
    return gradeService.getAllGrades(
      page: params['page'] ?? 0,
      size: params['size'] ?? 10,
      sortBy: params['sortBy'] ?? 'grade',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Provider para obtener un grado por ID
final getGradeByIdProvider = FutureProvider.family<Grade, int>(
  (ref, id) async {
    final gradeService = ref.read(gradeServiceProvider);
    return gradeService.getGradeById(id);
  },
);

// Hook para obtener todos los grados
class UseGetAllGrades {
  final WidgetRef ref;

  UseGetAllGrades(this.ref);

  Future<PaginatedResponse<Grade>> getAllGrades({
    int page = 0,
    int size = 10,
    String sortBy = 'grade',
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
      ref.invalidate(getAllGradesProvider(params));
      
      // Esperamos el resultado
      return await ref.read(getAllGradesProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener grados: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para crear un grado
class UseCreateGrade {
  final WidgetRef ref;
  final IGradeService gradeService;

  UseCreateGrade(this.ref) 
      : gradeService = ref.read(gradeServiceProvider);

  Future<Grade> createGrade(Grade grade) async {
    try {
      // Ejecutar la operación de crear grado
      final createdGrade = await gradeService.createGrade(grade);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllGradesProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Grado creado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return createdGrade;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al crear grado: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para actualizar un grado
class UseUpdateGrade {
  final WidgetRef ref;
  final IGradeService gradeService;

  UseUpdateGrade(this.ref)
      : gradeService = ref.read(gradeServiceProvider);

  Future<Grade> updateGrade(int id, Grade grade) async {
    try {
      // Ejecutar la operación de actualizar grado
      final updatedGrade = await gradeService.updateGrade(id, grade);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllGradesProvider);
      ref.invalidate(getGradeByIdProvider(id));
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Grado actualizado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return updatedGrade;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al actualizar grado: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para eliminar un grado
class UseDeleteGrade {
  final WidgetRef ref;
  final IGradeService gradeService;

  UseDeleteGrade(this.ref)
      : gradeService = ref.read(gradeServiceProvider);

  Future<bool> deleteGrade(int id) async {
    try {
      // Ejecutar la operación de eliminar grado
      final result = await gradeService.deleteGrade(id);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllGradesProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Grado eliminado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return result;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al eliminar grado: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener un grado por ID
class UseGetGradeById {
  final WidgetRef ref;

  UseGetGradeById(this.ref);

  Future<Grade> getGradeById(int id) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getGradeByIdProvider(id));
      
      // Esperamos el resultado
      return await ref.read(getGradeByIdProvider(id).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener grado: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para asignar materias a un grado
class UseAssignSubjectsToGrade {
  final WidgetRef ref;
  final IGradeService gradeService;

  UseAssignSubjectsToGrade(this.ref)
      : gradeService = ref.read(gradeServiceProvider);

  Future<bool> assignSubjectsToGrade(GradeSubjectAssignment assignment) async {
    try {
      // Ejecutar la operación de asignar materias
      final result = await gradeService.assignSubjectsToGrade(assignment);
      
      // Invalidar consultas para refrescar datos
      ref.invalidate(getGradeByIdProvider(assignment.gradeId));
      ref.invalidate(getAllGradesProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Materias asignadas exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return result;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al asignar materias: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
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