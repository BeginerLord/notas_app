import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/student_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:notas_academicas/src/services/Student/implementation/student_service_impl.dart';
import 'package:notas_academicas/src/services/Student/interfaces/i_student_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de estudiantes
final studentServiceProvider = Provider<IStudentService>((ref) {
  final api = ref.watch(apiProvider);
  return StudentServiceImpl(api);
});

// Hook para obtener todos los estudiantes
class UseGetAllStudents {
  final WidgetRef ref;
  final IStudentService studentService;
  final _allStudentsProvider = queryProviderFamily<PaginatedResponse<Student>>();

  UseGetAllStudents(this.ref)
      : studentService = ref.read(studentServiceProvider);

  String _getProviderKey(int page, int size, String sortBy, String direction) {
    return 'all_students_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> fetch({
    int page = 0,
    int size = 10,
    String sortBy = 'userEntity.username',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(page, size, sortBy, direction);
    final notifier = ref.read(_allStudentsProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await studentService.getAllStudents(
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Student>> getState({
    int page = 0,
    int size = 10,
    String sortBy = 'userEntity.username',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    return ref.watch(_allStudentsProvider(key));
  }
  
  void invalidate({
    int page = 0,
    int size = 10,
    String sortBy = 'userEntity.username',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    ref.invalidate(_allStudentsProvider(key));
  }
}

// Hook para crear un estudiante
class UseCreateStudent {
  final WidgetRef ref;
  final IStudentService studentService;
  final _createStudentProvider = queryProviderFamily<Student>();

  UseCreateStudent(this.ref) 
      : studentService = ref.read(studentServiceProvider);

  Future<void> createStudent(Student student) async {
    final key = 'create_student_${DateTime.now().millisecondsSinceEpoch}';
    final notifier = ref.read(_createStudentProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await studentService.createStudent(student);
    });
    
    final state = ref.read(_createStudentProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al crear estudiante: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas para forzar recarga de datos
      UseGetAllStudents(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Estudiante creado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Student> getState(String key) {
    return ref.watch(_createStudentProvider(key));
  }
}

// Hook para actualizar un estudiante
class UseUpdateStudent {
  final WidgetRef ref;
  final IStudentService studentService;
  final _updateStudentProvider = queryProviderFamily<Student>();

  UseUpdateStudent(this.ref)
      : studentService = ref.read(studentServiceProvider);

  String _getProviderKey(String uuid) => 'update_student_$uuid';

  Future<void> updateStudent(String uuid, Student student) async {
    final key = _getProviderKey(uuid);
    final notifier = ref.read(_updateStudentProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await studentService.updateStudent(uuid, student);
    });
    
    final state = ref.read(_updateStudentProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al actualizar estudiante: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas
      UseGetAllStudents(ref).invalidate();
      UseGetStudentById(ref).invalidate(uuid);
      
      Fluttertoast.showToast(
        msg: "Estudiante actualizado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Student> getState(String uuid) {
    return ref.watch(_updateStudentProvider(_getProviderKey(uuid)));
  }
}

// Hook para eliminar un estudiante
class UseDeleteStudent {
  final WidgetRef ref;
  final IStudentService studentService;
  final _deleteStudentProvider = queryProviderFamily<bool>();

  UseDeleteStudent(this.ref)
      : studentService = ref.read(studentServiceProvider);

  String _getProviderKey(String uuid) => 'delete_student_$uuid';

  Future<void> deleteStudent(String uuid) async {
    final key = _getProviderKey(uuid);
    final notifier = ref.read(_deleteStudentProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await studentService.deleteStudent(uuid);
    });
    
    final state = ref.read(_deleteStudentProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al eliminar estudiante: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null && state.data!) {
      // Invalidar consultas previas
      UseGetAllStudents(ref).invalidate();
      
      Fluttertoast.showToast(
        msg: "Estudiante eliminado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<bool> getState(String uuid) {
    return ref.watch(_deleteStudentProvider(_getProviderKey(uuid)));
  }
}

// Hook para obtener un estudiante por ID
class UseGetStudentById {
  final WidgetRef ref;
  final IStudentService studentService;
  final _studentByIdProvider = queryProviderFamily<Student>();

  UseGetStudentById(this.ref)
      : studentService = ref.read(studentServiceProvider);

  String _getProviderKey(String uuid) => 'student_by_id_$uuid';

  Future<void> fetch(String uuid) async {
    final key = _getProviderKey(uuid);
    final notifier = ref.read(_studentByIdProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await studentService.getStudentById(uuid);
    });
  }
  
  QueryState<Student> getState(String uuid) {
    return ref.watch(_studentByIdProvider(_getProviderKey(uuid)));
  }
  
  void invalidate(String uuid) {
    ref.invalidate(_studentByIdProvider(_getProviderKey(uuid)));
  }
}

// Extension para facilitar el uso de hooks en widgets
extension StudentHooksExtension on BuildContext {
  WidgetRef get _ref => ProviderScope.containerOf(this) as WidgetRef;

  UseGetAllStudents get useGetAllStudents => UseGetAllStudents(_ref);
  UseCreateStudent get useCreateStudent => UseCreateStudent(_ref);
  UseUpdateStudent get useUpdateStudent => UseUpdateStudent(_ref);
  UseDeleteStudent get useDeleteStudent => UseDeleteStudent(_ref);
  UseGetStudentById get useGetStudentById => UseGetStudentById(_ref);
}