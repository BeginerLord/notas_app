import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/subjects_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/services/Subjects/subject_service_impl.dart';
import 'package:notas_academicas/src/services/Subjects/i_subject_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de materias
final subjectServiceProvider = Provider<ISubjectService>((ref) {
  final api = ref.watch(apiProvider);
  return SubjectServiceImpl(api);
});

// Provider para obtener todas las materias con paginación
final getAllSubjectsProvider = FutureProvider.family<PaginatedResponse<Subject>, Map<String, dynamic>>(
  (ref, params) async {
    final subjectService = ref.read(subjectServiceProvider);
    return subjectService.getAllSubjects(
      page: params['page'] ?? 0,
      size: params['size'] ?? 10, 
      sortBy: params['sortBy'] ?? 'subjectName',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Provider para obtener una materia por ID
final getSubjectByIdProvider = FutureProvider.family<Subject, int>(
  (ref, id) async {
    final subjectService = ref.read(subjectServiceProvider);
    return subjectService.getSubjectById(id);
  },
);

// Provider para obtener materias por profesor con paginación
final getSubjectsByProfessorProvider = FutureProvider.family<PaginatedResponse<Subject>, Map<String, dynamic>>(
  (ref, params) async {
    final subjectService = ref.read(subjectServiceProvider);
    return subjectService.getSubjectsByProfessor(
      professorId: params['professorId'] as int,
      page: params['page'] ?? 0,
      size: params['size'] ?? 10,
      sortBy: params['sortBy'] ?? 'subjectName',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Provider para buscar materias por nombre con paginación
final searchSubjectsByNameProvider = FutureProvider.family<PaginatedResponse<Subject>, Map<String, dynamic>>(
  (ref, params) async {
    final subjectService = ref.read(subjectServiceProvider);
    return subjectService.searchSubjectsByName(
      subjectName: params['subjectName'] as String,
      page: params['page'] ?? 0,
      size: params['size'] ?? 10,
      sortBy: params['sortBy'] ?? 'subjectName',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Hook para obtener todas las materias
class UseGetAllSubjects {
  final WidgetRef ref;

  UseGetAllSubjects(this.ref);

  Future<PaginatedResponse<Subject>> getAllSubjects({
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
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
      ref.invalidate(getAllSubjectsProvider(params));
      
      // Esperamos el resultado
      return await ref.read(getAllSubjectsProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener materias: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para crear una materia
class UseCreateSubject {
  final WidgetRef ref;
  final ISubjectService subjectService;

  UseCreateSubject(this.ref) 
      : subjectService = ref.read(subjectServiceProvider);

  Future<Subject> createSubject(Subject subject) async {
    try {
      // Ejecutar la operación de crear materia
      final createdSubject = await subjectService.createSubject(subject);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllSubjectsProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Materia creada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return createdSubject;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al crear materia: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para actualizar una materia
class UseUpdateSubject {
  final WidgetRef ref;
  final ISubjectService subjectService;

  UseUpdateSubject(this.ref)
      : subjectService = ref.read(subjectServiceProvider);

  Future<Subject> updateSubject(int id, Subject subject) async {
    try {
      // Ejecutar la operación de actualizar materia
      final updatedSubject = await subjectService.updateSubject(id, subject);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllSubjectsProvider);
      ref.invalidate(getSubjectByIdProvider(id));
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Materia actualizada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return updatedSubject;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al actualizar materia: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para eliminar una materia
class UseDeleteSubject {
  final WidgetRef ref;
  final ISubjectService subjectService;

  UseDeleteSubject(this.ref)
      : subjectService = ref.read(subjectServiceProvider);

  Future<bool> deleteSubject(int id) async {
    try {
      // Ejecutar la operación de eliminar materia
      final result = await subjectService.deleteSubject(id);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllSubjectsProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Materia eliminada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return result;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al eliminar materia: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener una materia por ID
class UseGetSubjectById {
  final WidgetRef ref;

  UseGetSubjectById(this.ref);

  Future<Subject> getSubjectById(int id) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getSubjectByIdProvider(id));
      
      // Esperamos el resultado
      return await ref.read(getSubjectByIdProvider(id).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener materia: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener materias por profesor
class UseGetSubjectsByProfessor {
  final WidgetRef ref;

  UseGetSubjectsByProfessor(this.ref);

  Future<PaginatedResponse<Subject>> getSubjectsByProfessor({
    required int professorId,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) async {
    try {
      final params = {
        'professorId': professorId,
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'direction': direction,
      };
      
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getSubjectsByProfessorProvider(params));
      
      // Esperamos el resultado
      return await ref.read(getSubjectsByProfessorProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener materias por profesor: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para buscar materias por nombre
class UseSearchSubjectsByName {
  final WidgetRef ref;

  UseSearchSubjectsByName(this.ref);

  Future<PaginatedResponse<Subject>> searchSubjectsByName({
    required String subjectName,
    int page = 0,
    int size = 10,
    String sortBy = 'subjectName',
    String direction = 'asc',
  }) async {
    try {
      final params = {
        'subjectName': subjectName,
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'direction': direction,
      };
      
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(searchSubjectsByNameProvider(params));
      
      // Esperamos el resultado
      return await ref.read(searchSubjectsByNameProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al buscar materias: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
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