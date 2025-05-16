import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/sections_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/services/section/section_service_impl.dart';
import 'package:notas_academicas/src/services/section/i_section_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de secciones
final sectionServiceProvider = Provider<ISectionService>((ref) {
  final api = ref.watch(apiProvider);
  return SectionServiceImpl(api);
});

// Provider para obtener todas las secciones con paginación
final getAllSectionsProvider = FutureProvider.family<PaginatedResponse<Section>, Map<String, dynamic>>(
  (ref, params) async {
    final sectionService = ref.read(sectionServiceProvider);
    return sectionService.getAllSections(
      page: params['page'] ?? 0,
      size: params['size'] ?? 10, 
      sortBy: params['sortBy'] ?? 'sectionName',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Provider para obtener una sección por ID
final getSectionByIdProvider = FutureProvider.family<Section, int>(
  (ref, id) async {
    final sectionService = ref.read(sectionServiceProvider);
    return sectionService.getSectionById(id);
  },
);

// Provider para obtener secciones por grado
final getSectionsByGradeIdProvider = FutureProvider.family<PaginatedResponse<Section>, Map<String, dynamic>>(
  (ref, params) async {
    final sectionService = ref.read(sectionServiceProvider);
    return sectionService.getSectionsByGradeId(
      gradeId: params['gradeId'] as int,
      page: params['page'] ?? 0,
      size: params['size'] ?? 10,
      sortBy: params['sortBy'] ?? 'sectionName',
      direction: params['direction'] ?? 'asc',
    );
  },
);

// Hook para obtener todas las secciones
class UseGetAllSections {
  final WidgetRef ref;

  UseGetAllSections(this.ref);

  Future<PaginatedResponse<Section>> getAllSections({
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
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
      ref.invalidate(getAllSectionsProvider(params));
      
      // Esperamos el resultado
      return await ref.read(getAllSectionsProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener secciones: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para crear una sección
class UseCreateSection {
  final WidgetRef ref;
  final ISectionService sectionService;

  UseCreateSection(this.ref) 
      : sectionService = ref.read(sectionServiceProvider);

  Future<Section> createSection(Section section) async {
    try {
      // Ejecutar la operación de crear sección
      final createdSection = await sectionService.createSection(section);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllSectionsProvider);
      
      // Si conocemos el gradeId, también invalidamos las secciones de ese grado
      if (section.gradeId != null) {
        ref.invalidate(getSectionsByGradeIdProvider);
      }
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Sección creada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return createdSection;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al crear sección: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para actualizar una sección
class UseUpdateSection {
  final WidgetRef ref;
  final ISectionService sectionService;

  UseUpdateSection(this.ref)
      : sectionService = ref.read(sectionServiceProvider);

  Future<Section> updateSection(int id, Section section) async {
    try {
      // Ejecutar la operación de actualizar sección
      final updatedSection = await sectionService.updateSection(id, section);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllSectionsProvider);
      ref.invalidate(getSectionByIdProvider(id));
      
      // Si conocemos el gradeId, también invalidamos las secciones de ese grado
      if (section.gradeId != null) {
        final params = {'gradeId': section.gradeId!};
        ref.invalidate(getSectionsByGradeIdProvider(params));
      }
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Sección actualizada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return updatedSection;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al actualizar sección: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para eliminar una sección
class UseDeleteSection {
  final WidgetRef ref;
  final ISectionService sectionService;

  UseDeleteSection(this.ref)
      : sectionService = ref.read(sectionServiceProvider);

  Future<bool> deleteSection(int id) async {
    try {
      // Obtener la sección antes de eliminarla para saber su gradeId
      final section = await ref.read(getSectionByIdProvider(id).future);
      
      // Ejecutar la operación de eliminar sección
      final result = await sectionService.deleteSection(id);
      
      // Invalidar consultas previas para forzar recarga de datos
      ref.invalidate(getAllSectionsProvider);
      
      // Si conocemos el gradeId, también invalidamos las secciones de ese grado
      if (section.gradeId != null) {
        final params = {'gradeId': section.gradeId!};
        ref.invalidate(getSectionsByGradeIdProvider(params));
      }
      
      // Mostrar mensaje de éxito
      Fluttertoast.showToast(
        msg: "Sección eliminada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      
      return result;
    } catch (error) {
      // Manejar errores y notificar
      Fluttertoast.showToast(
        msg: "Error al eliminar sección: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener una sección por ID
class UseGetSectionById {
  final WidgetRef ref;

  UseGetSectionById(this.ref);

  Future<Section> getSectionById(int id) async {
    try {
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getSectionByIdProvider(id));
      
      // Esperamos el resultado
      return await ref.read(getSectionByIdProvider(id).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener sección: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Hook para obtener secciones por grado
class UseGetSectionsByGradeId {
  final WidgetRef ref;

  UseGetSectionsByGradeId(this.ref);

  Future<PaginatedResponse<Section>> getSectionsByGradeId({
    required int gradeId,
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
    String direction = 'asc',
  }) async {
    try {
      final params = {
        'gradeId': gradeId,
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'direction': direction,
      };
      
      // Invalidamos el provider para forzar una recarga
      ref.invalidate(getSectionsByGradeIdProvider(params));
      
      // Esperamos el resultado
      return await ref.read(getSectionsByGradeIdProvider(params).future);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error al obtener secciones por grado: ${error.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      rethrow;
    }
  }
}

// Extension para facilitar el uso de hooks en widgets
extension SectionHooksExtension on BuildContext {
  WidgetRef get _ref => ProviderScope.containerOf(this) as WidgetRef;

  UseGetAllSections get useGetAllSections => UseGetAllSections(_ref);
  UseCreateSection get useCreateSection => UseCreateSection(_ref);
  UseUpdateSection get useUpdateSection => UseUpdateSection(_ref);
  UseDeleteSection get useDeleteSection => UseDeleteSection(_ref);
  UseGetSectionById get useGetSectionById => UseGetSectionById(_ref);
  UseGetSectionsByGradeId get useGetSectionsByGradeId => UseGetSectionsByGradeId(_ref);
}