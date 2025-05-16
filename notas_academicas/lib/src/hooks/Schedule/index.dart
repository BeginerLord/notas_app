import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/schedule_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/services/Schedule/schedule_service_impl.dart';
import 'package:notas_academicas/src/services/Schedule/i_schedule_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de horarios
final scheduleServiceProvider = Provider<IScheduleService>((ref) {
  final api = ref.watch(apiProvider);
  return ScheduleServiceImpl(api);
});

// Provider para obtener horarios de un profesor
final getProfessorScheduleProvider = FutureProvider.family<List<Schedule>, String>(
  (ref, uuid) async {
    final scheduleService = ref.read(scheduleServiceProvider);
    return scheduleService.getProfessorSchedule(uuid);
  },
);

// Provider para obtener horarios de un estudiante
final getStudentScheduleProvider = FutureProvider.family<List<Schedule>, String>(
  (ref, studentUuid) async {
    final scheduleService = ref.read(scheduleServiceProvider);
    return scheduleService.getStudentSchedule(studentUuid);
  },
);

// Hook para asignar horario a un profesor
class UseAssignScheduleToProfessor {
  final WidgetRef ref;
  final IScheduleService scheduleService;

  UseAssignScheduleToProfessor(this.ref)
      : scheduleService = ref.read(scheduleServiceProvider);

  Future<Schedule> assignScheduleToProfessor(Schedule schedule) async {
    try {
      // Ejecutar la operación de asignar horario a profesor
      final assignedSchedule = await scheduleService.assignScheduleToProfessor(schedule);
      
      // Invalidar consultas previas para forzar recarga de datos
      // Si tenemos el UUID del profesor, invalidamos sus horarios específicos
      if (schedule.professorUsername != null) {
        ref.invalidate(getProfessorScheduleProvider(schedule.professorUsername!));
      }
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Horario asignado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return assignedSchedule;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al asignar horario: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para confirmar horario de profesor
class UseConfirmProfessorSchedule {
  final WidgetRef ref;
  final IScheduleService scheduleService;

  UseConfirmProfessorSchedule(this.ref)
      : scheduleService = ref.read(scheduleServiceProvider);

  Future<bool> confirmProfessorSchedule(String profesorUuid, int horarioId) async {
    try {
      // Ejecutar la operación de confirmar horario de profesor
      final result = await scheduleService.confirmProfessorSchedule(profesorUuid, horarioId);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getProfessorScheduleProvider(profesorUuid));
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Horario confirmado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return result;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al confirmar horario: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener horarios de un profesor
class UseGetProfessorSchedule {
  final WidgetRef ref;

  UseGetProfessorSchedule(this.ref);

  Future<List<Schedule>> getProfessorSchedule(String uuid) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getProfessorScheduleProvider(uuid));
      
      // Esperamos el resultado
      return await ref.read(getProfessorScheduleProvider(uuid).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener horarios del profesor: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener horarios de un estudiante
class UseGetStudentSchedule {
  final WidgetRef ref;

  UseGetStudentSchedule(this.ref);

  Future<List<Schedule>> getStudentSchedule(String studentUuid) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getStudentScheduleProvider(studentUuid));
      
      // Esperamos el resultado
      return await ref.read(getStudentScheduleProvider(studentUuid).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener horarios del estudiante: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Extension para facilitar el uso de hooks en widgets
extension ScheduleHooksExtension on BuildContext {
  WidgetRef get _ref => ProviderScope.containerOf(this) as WidgetRef;

  UseAssignScheduleToProfessor get useAssignScheduleToProfessor => 
      UseAssignScheduleToProfessor(_ref);
  UseConfirmProfessorSchedule get useConfirmProfessorSchedule => 
      UseConfirmProfessorSchedule(_ref);
  UseGetProfessorSchedule get useGetProfessorSchedule => 
      UseGetProfessorSchedule(_ref);
  UseGetStudentSchedule get useGetStudentSchedule => 
      UseGetStudentSchedule(_ref);
}