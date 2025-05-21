import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/widgets/dashboard/professor/professor_specialty.dart';
import 'package:notas_academicas/src/widgets/dashboard/search_bar.dart';

class Filters extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String? selectedSpecialty;
  final ValueChanged<String?> onSpecialtyChanged;
  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onClear;
  final VoidCallback onApply;

  const Filters({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedSpecialty,
    required this.onSpecialtyChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onClear,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros',
            style: AppStyles.dashboardTitleStyle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 15),
          
          // Usar el widget SearchBar reutilizable
          SearchBarWidget(
            initialValue: searchQuery,
            onChanged: onSearchChanged,
            hintText: 'Buscar profesor...',
          ),
          
          const SizedBox(height: 15),
          
          // Dropdowns en su propia fila
          Row(
            children: [
              // Dropdown de especialidad
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: InputBorder.none,
                    ),
                    hint: const Text('Especialidad'),
                    value: selectedSpecialty,
                    items: [
                      'Todas',
                      ...ProfessorSpecialtyDropdown.specialties,
                    ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: onSpecialtyChanged,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
              
              const SizedBox(width: 15),
              
              // Dropdown de estado
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      border: InputBorder.none,
                    ),
                    hint: const Text('Estado'),
                    value: selectedStatus,
                    items: ['Todos', 'Activo', 'Inactivo']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: onStatusChanged,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 15),
          
          // Botón para quitar filtros
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: onClear,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: AppStyles.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Quitar Filtro'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}