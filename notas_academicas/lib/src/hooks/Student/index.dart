
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/student_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/services/Student/implementation/student_service_impl.dart';
import 'package:notas_academicas/src/services/Student/interfaces/i_student_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de estudiantes
final studentServiceProvider = Provider<IStudentService>((ref) {
  final api = ref.watch(apiProvider);
  return StudentServiceImpl(api);
});

// Provider para obtener todos los estudiantes con paginación
final getAllStudentsProvider = FutureProvider.family<PaginatedResponse<Student>, Map<String, dynamic>>(
  (ref, params) async {
    final studentService = ref.read(studentServiceProvider);
    return studentService.getAllStudents(
      page: params['page'] ?? 0,
      size: params['size'] ?? 10, 
      sortBy: params['sortBy'] ?? 'userEntity.username',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Provider para obtener un estudiante por ID
final getStudentByIdProvider = FutureProvider.family<Student, String>(
  (ref, uuid) async {
    final studentService = ref.read(studentServiceProvider);
    return studentService.getStudentById(uuid);
  },
);

// Hook para obtener todos los estudiantes
class UseGetAllStudents {
  final WidgetRef ref;

  UseGetAllStudents(this.ref);

  Future<PaginatedResponse<Student>> getAllStudents({
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
      ref.invalidate(getAllStudentsProvider(params));
      
      // Esperamos el resultado
      return await ref.read(getAllStudentsProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener estudiantes: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para crear un estudiante
class UseCreateStudent {
  final WidgetRef ref;
  final IStudentService studentService;

  UseCreateStudent(this.ref) 
      : studentService = ref.read(studentServiceProvider);

  Future<Student> createStudent(Student student) async {
    try {
      // Ejecutar la operación de crear estudiante
      final createdStudent = await studentService.createStudent(student);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllStudentsProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Estudiante creado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return createdStudent;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al crear estudiante: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para actualizar un estudiante
class UseUpdateStudent {
  final WidgetRef ref;
  final IStudentService studentService;

  UseUpdateStudent(this.ref)
      : studentService = ref.read(studentServiceProvider);

  Future<Student> updateStudent(String uuid, Student student) async {
    try {
      // Ejecutar la operación de actualizar estudiante
      final updatedStudent = await studentService.updateStudent(uuid, student);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllStudentsProvider);
      ref.invalidate(getStudentByIdProvider(uuid));
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Estudiante actualizado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return updatedStudent;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al actualizar estudiante: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para eliminar un estudiante
class UseDeleteStudent {
  final WidgetRef ref;
  final IStudentService studentService;

  UseDeleteStudent(this.ref)
      : studentService = ref.read(studentServiceProvider);

  Future<bool> deleteStudent(String uuid) async {
    try {
      // Ejecutar la operación de eliminar estudiante
      final result = await studentService.deleteStudent(uuid);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllStudentsProvider);
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Estudiante eliminado exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return result;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al eliminar estudiante: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener un estudiante por ID
class UseGetStudentById {
  final WidgetRef ref;

  UseGetStudentById(this.ref);

  Future<Student> getStudentById(String uuid) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getStudentByIdProvider(uuid));
      
      // Esperamos el resultado
      return await ref.read(getStudentByIdProvider(uuid).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener estudiante: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
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