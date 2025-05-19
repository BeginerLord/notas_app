import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';

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
          Text('Filtros', style: AppStyles.dashboardTitleStyle.copyWith(fontSize: 18)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: searchQuery),
                  decoration: InputDecoration(
                    hintText: 'Buscar profesor...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
              const SizedBox(width: 15),
              DropdownButton<String>(
                hint: const Text('Especialidad'),
                value: selectedSpecialty,
                items: ['Todas','Matemáticas','Ciencias','Historia','Lenguaje','Educación Física']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onSpecialtyChanged,
              ),
              const SizedBox(width: 15),
              DropdownButton<String>(
                hint: const Text('Estado'),
                value: selectedStatus,
                items: ['Todos','Activo','Inactivo']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onStatusChanged,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: onClear,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.lightGrey,
                  foregroundColor: AppStyles.darkBlue,
                ),
                child: const Text('Quitar Filtro'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onApply,
                style: AppStyles.primaryButtonStyle,
                child: const Text('Filtrar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
