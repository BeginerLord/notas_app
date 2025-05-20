import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/professor_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:notas_academicas/src/services/Professor/implenentation/professor_service_impl.dart';
import 'package:notas_academicas/src/services/Professor/interfaces/i_professor_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de profesores
final professorServiceProvider = Provider<IProfessorService>((ref) {
  final api = ref.watch(apiProvider);
  return ProfessorServiceImpl(api);
});

// Hook para obtener todos los profesores
class UseGetAllProfessors {
  final WidgetRef ref;
  final IProfessorService professorService;
  final _allProfessorsProvider = queryProviderFamily<PaginatedResponse<Professor>>();

  UseGetAllProfessors(this.ref)
      : professorService = ref.read(professorServiceProvider);

  String _getProviderKey(int page, int size, String sortBy, String direction) {
    return 'all_professors_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> fetch({
    int page = 0,
    int size = 10,
    String sortBy = 'userEntity.username',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(page, size, sortBy, direction);
    final notifier = ref.read(_allProfessorsProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await professorService.getAllProfessors(
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Professor>> getState({
    int page = 0,
    int size = 10,
    String sortBy = 'userEntity.username',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    return ref.watch(_allProfessorsProvider(key));
  }
  
  void invalidate({
    int page = 0,
    int size = 10,
    String sortBy = 'userEntity.username',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    ref.invalidate(_allProfessorsProvider(key));
  }
}

// Hook para crear un profesor
class UseCreateProfessor {
  final WidgetRef ref;
  final IProfessorService professorService;
  final _createProfessorProvider = queryProviderFamily<Professor>();

  UseCreateProfessor(this.ref) 
      : professorService = ref.read(professorServiceProvider);

  Future<void> createProfessor(Professor professor) async {
    final key = 'create_professor_${DateTime.now().millisecondsSinceEpoch}';
    final notifier = ref.read(_createProfessorProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await professorService.createProfessor(professor);
    });
    
    final state = ref.read(_createProfessorProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al crear profesor: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas para forzar recarga de datos
      UseGetAllProfessors(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Profesor creado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Professor> getState(String key) {
    return ref.watch(_createProfessorProvider(key));
  }
}

// Hook para actualizar un profesor
class UseUpdateProfessor {
  final WidgetRef ref;
  final IProfessorService professorService;
  final _updateProfessorProvider = queryProviderFamily<Professor>();

  UseUpdateProfessor(this.ref)
      : professorService = ref.read(professorServiceProvider);

  String _getProviderKey(String uuid) => 'update_professor_$uuid';

  Future<void> updateProfessor(String uuid, Professor professor) async {
    final key = _getProviderKey(uuid);
    final notifier = ref.read(_updateProfessorProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await professorService.updateProfessor(uuid, professor);
    });
    
    final state = ref.read(_updateProfessorProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al actualizar profesor: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas
      UseGetAllProfessors(ref).invalidate();
      UseGetProfessorById(ref).invalidate(uuid);
      
      Fluttertoast.showToast(
        msg: "Profesor actualizado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Professor> getState(String uuid) {
    return ref.watch(_updateProfessorProvider(_getProviderKey(uuid)));
  }
}

// Hook para eliminar un profesor
class UseDeleteProfessor {
  final WidgetRef ref;
  final IProfessorService professorService;
  final _deleteProfessorProvider = queryProviderFamily<bool>();

  UseDeleteProfessor(this.ref)
      : professorService = ref.read(professorServiceProvider);

  String _getProviderKey(String uuid) => 'delete_professor_$uuid';

  Future<void> deleteProfessor(String uuid) async {
    final key = _getProviderKey(uuid);
    final notifier = ref.read(_deleteProfessorProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await professorService.deleteProfessor(uuid);
    });
    
    final state = ref.read(_deleteProfessorProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al eliminar profesor: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null && state.data!) {
      // Invalidar consultas previas
      UseGetAllProfessors(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Profesor eliminado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<bool> getState(String uuid) {
    return ref.watch(_deleteProfessorProvider(_getProviderKey(uuid)));
  }
}

// Hook para obtener un profesor por ID
class UseGetProfessorById {
  final WidgetRef ref;
  final IProfessorService professorService;
  final _professorByIdProvider = queryProviderFamily<Professor>();

  UseGetProfessorById(this.ref)
      : professorService = ref.read(professorServiceProvider);

  String _getProviderKey(String uuid) => 'professor_by_id_$uuid';

  Future<void> fetch(String uuid) async {
    final key = _getProviderKey(uuid);
    final notifier = ref.read(_professorByIdProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await professorService.getProfessorById(uuid);
    });
  }
  
  QueryState<Professor> getState(String uuid) {
    return ref.watch(_professorByIdProvider(_getProviderKey(uuid)));
  }
  
  void invalidate(String uuid) {
    ref.invalidate(_professorByIdProvider(_getProviderKey(uuid)));
  }
}

// Hook para obtener profesores por especialidad
class UseGetProfessorsBySpecialty {
  final WidgetRef ref;
  final IProfessorService professorService;
  final _professorsBySpecialtyProvider = queryProviderFamily<List<Professor>>();

  UseGetProfessorsBySpecialty(this.ref)
      : professorService = ref.read(professorServiceProvider);

  String _getProviderKey(String especialidad) => 'professors_by_specialty_$especialidad';

  Future<void> fetch(String especialidad) async {
    final key = _getProviderKey(especialidad);
    final notifier = ref.read(_professorsBySpecialtyProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await professorService.getProfessorsBySpecialty(especialidad);
    });
  }
  
  QueryState<List<Professor>> getState(String especialidad) {
    return ref.watch(_professorsBySpecialtyProvider(_getProviderKey(especialidad)));
  }
  
  void invalidate(String especialidad) {
    ref.invalidate(_professorsBySpecialtyProvider(_getProviderKey(especialidad)));
  }
}

// Hook para obtener carga académica de un profesor
class UseGetProfessorAcademicLoad {
  final WidgetRef ref;
  final IProfessorService professorService;
  final _academicLoadProvider = queryProviderFamily<List<AcademicLoad>>();

  UseGetProfessorAcademicLoad(this.ref)
      : professorService = ref.read(professorServiceProvider);

  String _getProviderKey(String uuid) => 'professor_academic_load_$uuid';

  Future<void> fetch(String uuid) async {
    final key = _getProviderKey(uuid);
    final notifier = ref.read(_academicLoadProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await professorService.getProfessorAcademicLoad(uuid);
    });
  }
  
  QueryState<List<AcademicLoad>> getState(String uuid) {
    return ref.watch(_academicLoadProvider(_getProviderKey(uuid)));
  }
  
  void invalidate(String uuid) {
    ref.invalidate(_academicLoadProvider(_getProviderKey(uuid)));
  }
}

// Hook para verificar disponibilidad de un profesor
class UseCheckProfessorAvailability {
  final WidgetRef ref;
  final IProfessorService professorService;
  final _availabilityProvider = queryProviderFamily<bool>();

  UseCheckProfessorAvailability(this.ref)
      : professorService = ref.read(professorServiceProvider);

  String _getProviderKey(AvailabilityQuery query) => 
      'professor_availability_${query.toString()}';

  Future<void> check(AvailabilityQuery query) async {
    final key = _getProviderKey(query);
    final notifier = ref.read(_availabilityProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await professorService.checkProfessorAvailability(query);
    });
  }
  
  QueryState<bool> getState(AvailabilityQuery query) {
    return ref.watch(_availabilityProvider(_getProviderKey(query)));
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