import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/widgets/dashboard/data_table_widget.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para la tabla de profesores
    final teachers = [
      {
        'ID': 'T001',
        'Nombre': 'Juan Rodríguez',
        'Email': 'juan.rodriguez@example.com',
        'Especialidad': 'Matemáticas',
        'Teléfono': '555-1234',
        'Estado': 'Activo',
      },
      {
        'ID': 'T002',
        'Nombre': 'Laura Martínez',
        'Email': 'laura.martinez@example.com',
        'Especialidad': 'Ciencias',
        'Teléfono': '555-5678',
        'Estado': 'Activo',
      },
      {
        'ID': 'T003',
        'Nombre': 'Roberto Sánchez',
        'Email': 'roberto.sanchez@example.com',
        'Especialidad': 'Historia',
        'Teléfono': '555-9012',
        'Estado': 'Inactivo',
      },
      {
        'ID': 'T004',
        'Nombre': 'Carmen López',
        'Email': 'carmen.lopez@example.com',
        'Especialidad': 'Lenguaje',
        'Teléfono': '555-3456',
        'Estado': 'Activo',
      },
      {
        'ID': 'T005',
        'Nombre': 'Miguel Torres',
        'Email': 'miguel.torres@example.com',
        'Especialidad': 'Educación Física',
        'Teléfono': '555-7890',
        'Estado': 'Activo',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestión de Profesores',
            style: AppStyles.titleStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Administra la información de los profesores',
            style: AppStyles.dashboardSubtitleStyle,
          ),
          const SizedBox(height: 20),
          
          // Filtros y búsqueda
          Container(
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar profesor...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    DropdownButton<String>(
                      hint: const Text('Especialidad'),
                      items: [
                        'Todas',
                        'Matemáticas',
                        'Ciencias',
                        'Historia',
                        'Lenguaje',
                        'Educación Física'
                      ]
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                    const SizedBox(width: 15),
                    DropdownButton<String>(
                      hint: const Text('Estado'),
                      items: ['Todos', 'Activo', 'Inactivo']
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Tabla de profesores
          DataTableWidget(
            title: 'Lista de Profesores',
            columns: [
              'ID',
              'Nombre',
              'Email',
              'Especialidad',
              'Teléfono',
              'Estado',
            ],
            data: teachers,
            onRowTap: (teacher) {
              // Implementar acción al hacer clic en un profesor
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Detalles del Profesor'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${teacher['ID']}'),
                      Text('Nombre: ${teacher['Nombre']}'),
                      Text('Email: ${teacher['Email']}'),
                      Text('Especialidad: ${teacher['Especialidad']}'),
                      Text('Teléfono: ${teacher['Teléfono']}'),
                      Text('Estado: ${teacher['Estado']}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cerrar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implementar edición
                        Navigator.pop(context);
                      },
                      style: AppStyles.primaryButtonStyle,
                      child: Text('Editar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
