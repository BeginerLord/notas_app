import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/hooks/Professor/index.dart';
import 'package:notas_academicas/src/models/professor_model.dart';
import 'package:notas_academicas/src/widgets/dashboard/data_table_widget.dart';
import 'package:notas_academicas/src/widgets/dashboard/filters.dart';
import 'package:notas_academicas/src/widgets/dashboard/pagination.dart';
import 'package:notas_academicas/src/widgets/dashboard/professor/professor_details_dialog.dart';
import 'package:notas_academicas/src/widgets/dashboard/professor/professor_create_dialog.dart';
import 'package:notas_academicas/src/widgets/dashboard/status.dart';

class ProfessorScreen extends HookConsumerWidget {
  const ProfessorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Estados reactivos
    final searchQuery = useState<String>('');
    final selectedSpecialty = useState<String?>(null);
    final selectedStatus = useState<String?>(null);
    final currentPage = useState<int>(0);
    final pageSize = useState<int>(20);
    final isLoading = useState<bool>(false);
    final isLoadingMore = useState<bool>(false);
    final hasMoreData = useState<bool>(true);
    final errorMessage = useState<String?>(null);
    final teachers = useState<List<Professor>>([]);
    final totalPages = useState<int>(0);

    // Hook de datos (usa ref, no context)
    final getAllHook = UseGetAllProfessors(ref);

    Future<void> loadInitial() async {
      try {
        isLoading.value = true;
        errorMessage.value = null;
        currentPage.value = 0;

        // Actualizado: usando el patrón correcto de fetch() y getState()
        await getAllHook.fetch(
          page: currentPage.value,
          size: pageSize.value,
          sortBy: 'userEntity.username',
          direction: 'asc',
        );

        final state = getAllHook.getState(
          page: currentPage.value,
          size: pageSize.value,
          sortBy: 'userEntity.username',
          direction: 'asc',
        );

        if (state.error != null) {
          errorMessage.value = state.error;
        } else if (state.data != null) {
          teachers.value = state.data!.content;
          totalPages.value = state.data!.totalPages;
          hasMoreData.value = currentPage.value < state.data!.totalPages - 1;
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> loadMore() async {
      if (isLoadingMore.value || !hasMoreData.value) return;
      try {
        isLoadingMore.value = true;
        currentPage.value++;

        // Actualizado: usando el patrón correcto de fetch() y getState()
        await getAllHook.fetch(
          page: currentPage.value,
          size: pageSize.value,
          sortBy: 'userEntity.username',
          direction: 'asc',
        );

        final state = getAllHook.getState(
          page: currentPage.value,
          size: pageSize.value,
          sortBy: 'userEntity.username',
          direction: 'asc',
        );

        if (state.error != null) {
          errorMessage.value = state.error;
        } else if (state.data != null) {
          teachers.value = [...teachers.value, ...state.data!.content];
          hasMoreData.value = currentPage.value < state.data!.totalPages - 1;
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoadingMore.value = false;
      }
    }

    // CAMBIO AQUÍ: Retrasar loadInitial hasta después de la construcción del widget
    useEffect(() {
      // Usar addPostFrameCallback para ejecutar después de que el build se complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loadInitial();
      });
      return null;
    }, []);

    List<Map<String, dynamic>> tableData() =>
        teachers.value
            .map(
              (p) => {
                'ID': p.uuid ?? '',
                'Nombre': p.username,
                'Email': p.email ?? 'N/D',
                'Especialidad': p.especialidad,
                'Teléfono': p.telefono,
                'Estado': p.uuid != null ? 'Activo' : 'Inactivo',
              },
            )
            .toList();

    List<Map<String, dynamic>> filteredData() {
      var data = tableData();
      final q = searchQuery.value.toLowerCase();
      if (q.isNotEmpty) {
        data = data
            .where(
              (r) =>
                  r['Nombre'].toLowerCase().contains(q) ||
                  r['Email'].toLowerCase().contains(q),
            )
            .toList();
      }
      if (selectedSpecialty.value != null &&
          selectedSpecialty.value != 'Todas') {
        data = data
            .where((r) => r['Especialidad'] == selectedSpecialty.value)
            .toList();
      }
      if (selectedStatus.value != null && selectedStatus.value != 'Todos') {
        data = data.where((r) => r['Estado'] == selectedStatus.value).toList();
      }
      return data;
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gestión de Profesores', style: AppStyles.titleStyle),
            const SizedBox(height: 5),
            Text(
              'Administra la información de los profesores',
              style: AppStyles.dashboardSubtitleStyle,
            ),
            const SizedBox(height: 20),

            Filters(
              searchQuery: searchQuery.value,
              onSearchChanged: (v) => searchQuery.value = v,
              selectedSpecialty: selectedSpecialty.value,
              onSpecialtyChanged: (v) => selectedSpecialty.value = v,
              selectedStatus: selectedStatus.value,
              onStatusChanged: (v) => selectedStatus.value = v,
              onClear: () {
                searchQuery.value = '';
                selectedSpecialty.value = null;
                selectedStatus.value = null;
                loadInitial();
              },
              onApply: loadInitial,
            ),

            const SizedBox(height: 20),

            Status(
              isLoading: isLoading.value,
              errorMessage: errorMessage.value,
              isEmpty: !isLoading.value && teachers.value.isEmpty,
              onRetry: loadInitial,
            ),

            if (!isLoading.value &&
                errorMessage.value == null &&
                teachers.value.isNotEmpty) ...[
              DataTableWidget(
                title: 'Lista de Profesores',
                columns: const [
                  'Nombre',
                  'Especialidad',
                  'Teléfono',
                  'Estado',
                  'ID',
                ],
                data: filteredData(),
                onRowTap: (row) {
                  showDialog(
                    context: context,
                    builder: (_) => ProfessorDetailsDialog(
                      teacher: row,
                      onDeleted: loadInitial,
                    ),
                  );
                },
              ),

              Pagination(
                currentPage: currentPage.value,
                totalPages: totalPages.value,
                hasMore: hasMoreData.value,
                isLoadingMore: isLoadingMore.value,
                onPageChanged: (page) {
                  currentPage.value = page;
                  loadInitial();
                },
                onLoadMore: loadMore,
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_teacher',
        backgroundColor: AppStyles.primaryBlue,
        onPressed: () async {
          // Muestra diálogo de creación y recarga al completar
          final result = await showDialog<bool>(
            context: context,
            builder: (_) => const ProfessorCreateDialog(),
          );

          if (result == true) {
            loadInitial(); // Recargar datos después de creación exitosa
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}