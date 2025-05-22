import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/schedule_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:notas_academicas/src/services/Schedule/schedule_service_impl.dart';
import 'package:notas_academicas/src/services/Schedule/i_schedule_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de horarios
final scheduleServiceProvider = Provider<IScheduleService>((ref) {
  final api = ref.watch(apiProvider);
  return ScheduleServiceImpl(api);
});

// Hook para asignar horario a un profesor
class UseAssignScheduleToProfessor {
  final WidgetRef ref;
  final IScheduleService scheduleService;
  final _assignScheduleProvider = queryProviderFamily<Schedule>();

  UseAssignScheduleToProfessor(this.ref)
    : scheduleService = ref.read(scheduleServiceProvider);

  String _getProviderKey(Schedule schedule) =>
      'assign_schedule_${DateTime.now().millisecondsSinceEpoch}';

  Future<void> assignSchedule(Schedule schedule) async {
    final key = _getProviderKey(schedule);
    final notifier = ref.read(_assignScheduleProvider(key).notifier);

    await notifier.fetchData(() async {
      return await scheduleService.assignScheduleToProfessor(schedule);
    });

    final state = ref.read(_assignScheduleProvider(key));

    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al asignar horario: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Si tenemos el username del profesor, invalidamos sus horarios específicos
      if (schedule.professorUsername != null) {
        UseGetProfessorSchedule(ref).invalidate(schedule.professorUsername!);
      }

      Fluttertoast.showToast(
        msg: "Horario asignado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  QueryState<Schedule> getState(String key) {
    return ref.watch(_assignScheduleProvider(key));
  }
}

// Hook para confirmar horario de profesor
class UseConfirmProfessorSchedule {
  final WidgetRef ref;
  final IScheduleService scheduleService;
  final _confirmScheduleProvider = queryProviderFamily<bool>();

  UseConfirmProfessorSchedule(this.ref)
    : scheduleService = ref.read(scheduleServiceProvider);

  String _getProviderKey(String profesorUuid, int horarioId) =>
      'confirm_schedule_${profesorUuid}_$horarioId';

  Future<void> confirmSchedule(String profesorUuid, int horarioId) async {
    final key = _getProviderKey(profesorUuid, horarioId);
    final notifier = ref.read(_confirmScheduleProvider(key).notifier);

    await notifier.fetchData(() async {
      return await scheduleService.confirmProfessorSchedule(
        profesorUuid,
        horarioId,
      );
    });

    final state = ref.read(_confirmScheduleProvider(key));

    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al confirmar horario: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null && state.data!) {
      // Invalidar consultas previas
      UseGetProfessorSchedule(ref).invalidate(profesorUuid);

      Fluttertoast.showToast(
        msg: "Horario confirmado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  QueryState<bool> getState(String profesorUuid, int horarioId) {
    return ref.watch(
      _confirmScheduleProvider(_getProviderKey(profesorUuid, horarioId)),
    );
  }
}

// Hook para obtener horarios de un profesor
class UseGetProfessorSchedule {
  final WidgetRef ref;
  final IScheduleService scheduleService;
  final _professorScheduleProvider = queryProviderFamily<List<Schedule>>();

  UseGetProfessorSchedule(this.ref)
    : scheduleService = ref.read(scheduleServiceProvider);

  String _getProviderKey(String uuid) => 'professor_schedule_$uuid';

  Future<void> fetch(String uuid) async {
    final key = _getProviderKey(uuid);
    final notifier = ref.read(_professorScheduleProvider(key).notifier);

    await notifier.fetchData(() async {
      return await scheduleService.getProfessorSchedule(uuid);
    });
  }

  QueryState<List<Schedule>> getState(String uuid) {
    return ref.watch(_professorScheduleProvider(_getProviderKey(uuid)));
  }

  void invalidate(String uuid) {
    ref.invalidate(_professorScheduleProvider(_getProviderKey(uuid)));
  }
}

// Hook para obtener horarios de un estudiante
class UseGetStudentSchedule {
  final WidgetRef ref;
  final IScheduleService scheduleService;
  final _studentScheduleProvider = queryProviderFamily<List<Schedule>>();

  UseGetStudentSchedule(this.ref)
    : scheduleService = ref.read(scheduleServiceProvider);

  String _getProviderKey(String studentUuid) => 'student_schedule_$studentUuid';

  Future<void> fetch(String studentUuid) async {
    final key = _getProviderKey(studentUuid);
    final notifier = ref.read(_studentScheduleProvider(key).notifier);

    await notifier.fetchData(() async {
      return await scheduleService.getStudentSchedule(studentUuid);
    });
  }

  QueryState<List<Schedule>> getState(String studentUuid) {
    return ref.watch(_studentScheduleProvider(_getProviderKey(studentUuid)));
  }

  void invalidate(String studentUuid) {
    ref.invalidate(_studentScheduleProvider(_getProviderKey(studentUuid)));
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
