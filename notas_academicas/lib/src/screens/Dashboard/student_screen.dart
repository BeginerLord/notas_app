import 'package:flutter/material.dart';
import 'package:notas_academicas/src/widgets/dashboard/data_table_widget.dart';
import 'package:notas_academicas/src/app_styles.dart';


class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para la tabla de estudiantes
    final students = [
      {
        'ID': '001',
        'Nombre': 'Ana García',
        'Email': 'ana.garcia@example.com',
        'Grado': '10°',
        'Sección': 'A',
        'Acudiente': 'María García',
        'Teléfono': '555-1234',
        'Estado': 'Activo',
      },
      {
        'ID': '002',
        'Nombre': 'Carlos Pérez',
        'Email': 'carlos.perez@example.com',
        'Grado': '11°',
        'Sección': 'B',
        'Acudiente': 'José Pérez',
        'Teléfono': '555-5678',
        'Estado': 'Activo',
      },
      {
        'ID': '003',
        'Nombre': 'María López',
        'Email': 'maria.lopez@example.com',
        'Grado': '9°',
        'Sección': 'C',
        'Acudiente': 'Pedro López',
        'Teléfono': '555-9012',
        'Estado': 'Activo',
      },
      {
        'ID': '004',
        'Nombre': 'Juan Rodríguez',
        'Email': 'juan.rodriguez@example.com',
        'Grado': '10°',
        'Sección': 'A',
        'Acudiente': 'Ana Rodríguez',
        'Teléfono': '555-3456',
        'Estado': 'Inactivo',
      },
      {
        'ID': '005',
        'Nombre': 'Laura Martínez',
        'Email': 'laura.martinez@example.com',
        'Grado': '11°',
        'Sección': 'B',
        'Acudiente': 'Carlos Martínez',
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
            'Gestión de Estudiantes',
            style: AppStyles.titleStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Administra la información de los estudiantes',
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
                          hintText: 'Buscar estudiante...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    DropdownButton<String>(
                      hint: const Text('Grado'),
                      items: ['Todos', '9°', '10°', '11°']
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                    const SizedBox(width: 15),
                    DropdownButton<String>(
                      hint: const Text('Sección'),
                      items: ['Todas', 'A', 'B', 'C']
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
          
          // Tabla de estudiantes
          DataTableWidget(
            title: 'Lista de Estudiantes',
            columns: [
              'ID',
              'Nombre',
              'Email',
              'Grado',
              'Sección',
              'Acudiente',
              'Teléfono',
              'Estado',
            ],
            data: students,
            onRowTap: (student) {
              // Implementar acción al hacer clic en un estudiante
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Detalles del Estudiante'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${student['ID']}'),
                      Text('Nombre: ${student['Nombre']}'),
                      Text('Email: ${student['Email']}'),
                      Text('Grado: ${student['Grado']}'),
                      Text('Sección: ${student['Sección']}'),
                      Text('Acudiente: ${student['Acudiente']}'),
                      Text('Teléfono: ${student['Teléfono']}'),
                      Text('Estado: ${student['Estado']}'),
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
