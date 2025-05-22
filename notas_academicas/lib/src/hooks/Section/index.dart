import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/models/pagination_model.dart';
import 'package:notas_academicas/src/models/sections_model.dart';
import 'package:notas_academicas/src/providers/api_provider.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:notas_academicas/src/services/section/section_service_impl.dart';
import 'package:notas_academicas/src/services/section/i_section_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// Provider para el servicio de secciones
final sectionServiceProvider = Provider<ISectionService>((ref) {
  final api = ref.watch(apiProvider);
  return SectionServiceImpl(api);
});

// Hook para obtener todas las secciones
class UseGetAllSections {
  final WidgetRef ref;
  final ISectionService sectionService;
  final _allSectionsProvider = queryProviderFamily<PaginatedResponse<Section>>();

  UseGetAllSections(this.ref)
      : sectionService = ref.read(sectionServiceProvider);

  String _getProviderKey(int page, int size, String sortBy, String direction) {
    return 'all_sections_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> fetch({
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(page, size, sortBy, direction);
    final notifier = ref.read(_allSectionsProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await sectionService.getAllSections(
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Section>> getState({
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    return ref.watch(_allSectionsProvider(key));
  }
  
  void invalidate({
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(page, size, sortBy, direction);
    ref.invalidate(_allSectionsProvider(key));
  }
}

// Hook para crear una sección
class UseCreateSection {
  final WidgetRef ref;
  final ISectionService sectionService;
  final _createSectionProvider = queryProviderFamily<Section>();

  UseCreateSection(this.ref) 
      : sectionService = ref.read(sectionServiceProvider);

  Future<void> createSection(Section section) async {
    final key = 'create_section_${DateTime.now().millisecondsSinceEpoch}';
    final notifier = ref.read(_createSectionProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await sectionService.createSection(section);
    });
    
    final state = ref.read(_createSectionProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al crear sección: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas para forzar recarga de datos
      UseGetAllSections(ref).invalidate();
      
      // Si conocemos el gradeId, también invalidamos las secciones de ese grado
      if (section.gradeId != null) {
        UseGetSectionsByGradeId(ref).invalidate(gradeId: section.gradeId!);
      }
      
      Fluttertoast.showToast(
        msg: "Sección creada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Section> getState(String key) {
    return ref.watch(_createSectionProvider(key));
  }
}

// Hook para actualizar una sección
class UseUpdateSection {
  final WidgetRef ref;
  final ISectionService sectionService;
  final _updateSectionProvider = queryProviderFamily<Section>();

  UseUpdateSection(this.ref)
      : sectionService = ref.read(sectionServiceProvider);

  String _getProviderKey(int id) => 'update_section_$id';

  Future<void> updateSection(int id, Section section) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_updateSectionProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await sectionService.updateSection(id, section);
    });
    
    final state = ref.read(_updateSectionProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al actualizar sección: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null) {
      // Invalidar consultas previas
      UseGetAllSections(ref).invalidate();
      UseGetSectionById(ref).invalidate(id);
      
      // Si conocemos el gradeId, también invalidamos las secciones de ese grado
      if (section.gradeId != null) {
        UseGetSectionsByGradeId(ref).invalidate(gradeId: section.gradeId!);
      }
      
      Fluttertoast.showToast(
        msg: "Sección actualizada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<Section> getState(int id) {
    return ref.watch(_updateSectionProvider(_getProviderKey(id)));
  }
}

// Hook para eliminar una sección
class UseDeleteSection {
  final WidgetRef ref;
  final ISectionService sectionService;
  final _deleteSectionProvider = queryProviderFamily<bool>();

  UseDeleteSection(this.ref)
      : sectionService = ref.read(sectionServiceProvider);

  String _getProviderKey(int id) => 'delete_section_$id';

  Future<void> deleteSection(int id, {int? gradeId}) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_deleteSectionProvider(key).notifier);
    
    // Si no conocemos el gradeId, intentamos obtenerlo primero
    if (gradeId == null) {
      try {
        final sectionState = UseGetSectionById(ref).getState(id);
        if (sectionState.data != null) {
          gradeId = sectionState.data!.gradeId;
        }
      } catch (e) {
        // Si no podemos obtener el gradeId, continuamos sin él
      }
    }
    
    await notifier.fetchData(() async {
      return await sectionService.deleteSection(id);
    });
    
    final state = ref.read(_deleteSectionProvider(key));
    
    if (state.error != null) {
      Fluttertoast.showToast(
        msg: "Error al eliminar sección: ${state.error}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(state.error);
    } else if (state.data != null && state.data!) {
      // Invalidar consultas previas
      UseGetAllSections(ref).invalidate();
      
      // Si conocemos el gradeId, también invalidamos las secciones de ese grado
      if (gradeId != null) {
        UseGetSectionsByGradeId(ref).invalidate(gradeId: gradeId);
      }
      
      Fluttertoast.showToast(
        msg: "Sección eliminada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
  
  QueryState<bool> getState(int id) {
    return ref.watch(_deleteSectionProvider(_getProviderKey(id)));
  }
}

// Hook para obtener una sección por ID
class UseGetSectionById {
  final WidgetRef ref;
  final ISectionService sectionService;
  final _sectionByIdProvider = queryProviderFamily<Section>();

  UseGetSectionById(this.ref)
      : sectionService = ref.read(sectionServiceProvider);

  String _getProviderKey(int id) => 'section_by_id_$id';

  Future<void> fetch(int id) async {
    final key = _getProviderKey(id);
    final notifier = ref.read(_sectionByIdProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await sectionService.getSectionById(id);
    });
  }
  
  QueryState<Section> getState(int id) {
    return ref.watch(_sectionByIdProvider(_getProviderKey(id)));
  }
  
  void invalidate(int id) {
    ref.invalidate(_sectionByIdProvider(_getProviderKey(id)));
  }
}

// Hook para obtener secciones por grado
class UseGetSectionsByGradeId {
  final WidgetRef ref;
  final ISectionService sectionService;
  final _sectionsByGradeIdProvider = queryProviderFamily<PaginatedResponse<Section>>();

  UseGetSectionsByGradeId(this.ref)
      : sectionService = ref.read(sectionServiceProvider);

  String _getProviderKey({
    required int gradeId,
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
    String direction = 'asc',
  }) {
    return 'sections_by_grade_${gradeId}_${page}_${size}_${sortBy}_$direction';
  }

  Future<void> fetch({
    required int gradeId,
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
    String direction = 'asc',
  }) async {
    final key = _getProviderKey(
      gradeId: gradeId,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    final notifier = ref.read(_sectionsByGradeIdProvider(key).notifier);
    
    await notifier.fetchData(() async {
      return await sectionService.getSectionsByGradeId(
        gradeId: gradeId,
        page: page,
        size: size, 
        sortBy: sortBy,
        direction: direction,
      );
    });
  }
  
  QueryState<PaginatedResponse<Section>> getState({
    required int gradeId,
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(
      gradeId: gradeId,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    return ref.watch(_sectionsByGradeIdProvider(key));
  }
  
  void invalidate({
    required int gradeId,
    int page = 0,
    int size = 10,
    String sortBy = 'sectionName',
    String direction = 'asc',
  }) {
    final key = _getProviderKey(
      gradeId: gradeId,
      page: page,
      size: size, 
      sortBy: sortBy,
      direction: direction,
    );
    ref.invalidate(_sectionsByGradeIdProvider(key));
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