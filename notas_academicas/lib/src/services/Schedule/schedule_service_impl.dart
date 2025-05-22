import 'package:notas_academicas/src/api/api_interface.dart';
import 'package:notas_academicas/src/models/schedule_model.dart';
import 'package:notas_academicas/src/services/Schedule/i_schedule_service.dart';

class ScheduleServiceImpl implements IScheduleService {
  final ApiInterface api;
  bool _isInitialized = false;

  // Constructor que recibe la instancia de la API
  ScheduleServiceImpl(this.api);

  Future<void> initializeApi() async {
    if (_isInitialized) return; // Evita inicializaciones repetidas
    await api.initialize();
    _isInitialized = true;
  }

  @override
  Future<Schedule> assignScheduleToProfessor(Schedule schedule) async {
    await initializeApi();

    // Convierte el horario a JSON usando el método específico para asignación
    final requestData = schedule.toAssignScheduleJson();

    // Realiza la solicitud POST al endpoint de asignación de horario
    final response = await api.post(
      '/schedule/asignarHorarioProfesor',
      data: requestData,
    );

    // Crea un objeto Schedule a partir de la respuesta
    return Schedule.fromGetResponse(response.data);
  }

  @override
  Future<bool> confirmProfessorSchedule(
    String profesorUuid,
    int horarioId,
  ) async {
    await initializeApi();

    // Realiza la solicitud PUT para confirmar el horario del profesor
    final url = '/schedule/profesor/$profesorUuid/horario/$horarioId/confirmar';
    await api.put(url, data: {});

    // Si no hay errores, se asume que la confirmación fue exitosa
    return true;
  }

  @override
  Future<List<Schedule>> getStudentSchedule(String studentUuid) async {
    await initializeApi();

    // Realiza la solicitud GET para obtener el horario del estudiante
    final response = await api.get('/schedule/student/$studentUuid/horario');

    // Convierte la respuesta en una lista de objetos Schedule
    final List<dynamic> scheduleList = response.data;
    return scheduleList.map((json) => Schedule.fromGetResponse(json)).toList();
  }

  @override
  Future<List<Schedule>> getProfessorSchedule(String uuid) async {
    await initializeApi();

    // Realiza la solicitud GET para obtener los horarios del profesor
    final response = await api.get('/schedule/professor/$uuid');

    // Convierte la respuesta en una lista de objetos Schedule
    final List<dynamic> scheduleList = response.data;
    return scheduleList.map((json) => Schedule.fromGetResponse(json)).toList();
  }
}