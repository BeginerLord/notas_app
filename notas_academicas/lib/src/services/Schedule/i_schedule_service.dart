import 'package:notas_academicas/src/models/schedule_model.dart';

abstract class IScheduleService {
  Future<Schedule> assignScheduleToProfessor(Schedule schedule);

  Future<bool> confirmProfessorSchedule(String profesorUuid, int horarioId);

  Future<List<Schedule>> getStudentSchedule(String studentUuid);

  Future<List<Schedule>> getProfessorSchedule(String uuid);
}
