import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/professor_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/services/Professor/implenentation/professor_service_impl.dart';
import 'package:notas_academicas/src/services/Professor/interfaces/i_professor_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de profesores
final professorServiceProvider = Provider<IProfessorService>((ref) {
  final api = ref.watch(apiProvider);
  return ProfessorServiceImpl(api);
});

// Provider para obtener todos los profesores con paginación
final getAllProfessorsProvider = FutureProvider.family<PaginatedResponse<Professor>, Map<String, dynamic>>(
  (ref, params) async {
    final professorService = ref.read(professorServiceProvider);
    return professorService.getAllProfessors(
      page: params['page'] ?? 0,
      size: params['size'] ?? 10, 
      sortBy: params['sortBy'] ?? 'userEntity.username',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Provider para obtener un profesor por ID
final getProfessorByIdProvider = FutureProvider.family<Professor, String>(
  (ref, uuid) async {
    final professorService = ref.read(professorServiceProvider);
    return professorService.getProfessorById(uuid);
  },
);

// Provider para obtener profesores por especialidad
final getProfessorsBySpecialtyProvider = FutureProvider.family<List<Professor>, String>(
  (ref, especialidad) async {
    final professorService = ref.read(professorServiceProvider);
    return professorService.getProfessorsBySpecialty(especialidad);
  },
);

// Provider para obtener carga académica de un profesor
final getProfessorAcademicLoadProvider = FutureProvider.family<List<AcademicLoad>, String>(
  (ref, uuid) async {
    final professorService = ref.read(professorServiceProvider);
    return professorService.getProfessorAcademicLoad(uuid);
  },
);

// Hook para obtener todos los profesores
class UseGetAllProfessors {
  final WidgetRef ref;

  UseGetAllProfessors(this.ref);

  Future<PaginatedResponse<Professor>> getAllProfessors({
    int page = 0,
    int size = 10,
    String sortBy = 'userEntity.username',
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
      ref.invalidate(getAllProfessorsProvider(params));
      
      // Esperamos el resultado
      return await ref.read(getAllProfessorsProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener profesores: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para crear un profesor
class UseCreateProfessor {
  final WidgetRef ref;
  final IProfessorService professorService;

  UseCreateProfessor(this.ref) 
      : professorService = ref.read(professorServiceProvider);

  Future<Professor> createProfessor(Professor professor) async {
    try {
      // Ejecutar la operación de crear profesor
      final createdProfessor = await professorService.createProfessor(professor);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllProfessorsProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Profesor creado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return createdProfessor;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al crear profesor: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para actualizar un profesor
class UseUpdateProfessor {
  final WidgetRef ref;
  final IProfessorService professorService;

  UseUpdateProfessor(this.ref)
      : professorService = ref.read(professorServiceProvider);

  Future<Professor> updateProfessor(String uuid, Professor professor) async {
    try {
      // Ejecutar la operación de actualizar profesor
      final updatedProfessor = await professorService.updateProfessor(uuid, professor);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllProfessorsProvider);
      ref.invalidate(getProfessorByIdProvider(uuid));
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Profesor actualizado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return updatedProfessor;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al actualizar profesor: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para eliminar un profesor
class UseDeleteProfessor {
  final WidgetRef ref;
  final IProfessorService professorService;

  UseDeleteProfessor(this.ref)
      : professorService = ref.read(professorServiceProvider);

  Future<bool> deleteProfessor(String uuid) async {
    try {
      // Ejecutar la operación de eliminar profesor
      final result = await professorService.deleteProfessor(uuid);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllProfessorsProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Profesor eliminado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return result;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al eliminar profesor: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener un profesor por ID
class UseGetProfessorById {
  final WidgetRef ref;

  UseGetProfessorById(this.ref);

  Future<Professor> getProfessorById(String uuid) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getProfessorByIdProvider(uuid));
      
      // Esperamos el resultado
      return await ref.read(getProfessorByIdProvider(uuid).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener profesor: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener profesores por especialidad
class UseGetProfessorsBySpecialty {
  final WidgetRef ref;

  UseGetProfessorsBySpecialty(this.ref);

  Future<List<Professor>> getProfessorsBySpecialty(String especialidad) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getProfessorsBySpecialtyProvider(especialidad));
      
      // Esperamos el resultado
      return await ref.read(getProfessorsBySpecialtyProvider(especialidad).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener profesores por especialidad: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener carga académica de un profesor
class UseGetProfessorAcademicLoad {
  final WidgetRef ref;

  UseGetProfessorAcademicLoad(this.ref);

  Future<List<AcademicLoad>> getProfessorAcademicLoad(String uuid) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getProfessorAcademicLoadProvider(uuid));
      
      // Esperamos el resultado
      return await ref.read(getProfessorAcademicLoadProvider(uuid).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener carga académica: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para verificar disponibilidad de un profesor
class UseCheckProfessorAvailability {
  final WidgetRef ref;
  final IProfessorService professorService;

  UseCheckProfessorAvailability(this.ref)
      : professorService = ref.read(professorServiceProvider);

  Future<bool> checkProfessorAvailability(AvailabilityQuery query) async {
    try {
      // Verificar disponibilidad del profesor
      return await professorService.checkProfessorAvailability(query);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al verificar disponibilidad: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Extension para facilitar el uso de hooks en widgets
extension ProfessorHooksExtension on BuildContext {
  WidgetRef get _ref => ProviderScope.containerOf(this) as WidgetRef;

  UseGetAllProfessors get useGetAllProfessors => UseGetAllProfessors(_ref);
  UseCreateProfessor get useCreateProfessor => UseCreateProfessor(_ref);
  UseUpdateProfessor get useUpdateProfessor => UseUpdateProfessor(_ref);
  UseDeleteProfessor get useDeleteProfessor => UseDeleteProfessor(_ref);
  UseGetProfessorById get useGetProfessorById => UseGetProfessorById(_ref);
  UseGetProfessorsBySpecialty get useGetProfessorsBySpecialty => UseGetProfessorsBySpecialty(_ref);
  UseGetProfessorAcademicLoad get useGetProfessorAcademicLoad => UseGetProfessorAcademicLoad(_ref);
  UseCheckProfessorAvailability get useCheckProfessorAvailability => UseCheckProfessorAvailability(_ref);
}