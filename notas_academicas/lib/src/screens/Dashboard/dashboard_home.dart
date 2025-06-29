import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/widgets/dashboard/data_table_widget.dart';
import 'package:notas_academicas/src/widgets/dashboard/stat_card.dart';


class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para las tablas
    final recentStudents = [
      {
        'ID': '001',
        'Nombre': 'Ana García',
        'Grado': '10°',
        'Sección': 'A',
        'Estado': 'Activo',
      },
      {
        'ID': '002',
        'Nombre': 'Carlos Pérez',
        'Grado': '11°',
        'Sección': 'B',
        'Estado': 'Activo',
      },
      {
        'ID': '003',
        'Nombre': 'María López',
        'Grado': '9°',
        'Sección': 'C',
        'Estado': 'Activo',
      },
    ];

    final recentTeachers = [
      {
        'ID': 'T001',
        'Nombre': 'Juan Rodríguez',
        'Especialidad': 'Matemáticas',
        'Estado': 'Activo',
      },
      {
        'ID': 'T002',
        'Nombre': 'Laura Martínez',
        'Especialidad': 'Ciencias',
        'Estado': 'Activo',
      },
      {
        'ID': 'T003',
        'Nombre': 'Roberto Sánchez',
        'Especialidad': 'Historia',
        'Estado': 'Inactivo',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: AppStyles.titleStyle,
          ),
          const SizedBox(height: 5),
          Text(
            'Bienvenido al panel de administración',
            style: AppStyles.dashboardSubtitleStyle,
          ),
          const SizedBox(height: 20),
          
          // Tarjetas de estadísticas con diseño responsivo
          LayoutBuilder(
            builder: (context, constraints) {
              // Determine number of columns based on screen width
              int crossAxisCount = 4; // Default for large screens
              
              if (constraints.maxWidth < 600) {
                crossAxisCount = 1; // For very small screens (phones in portrait)
              } else if (constraints.maxWidth < 900) {
                crossAxisCount = 2; // For medium screens (phones in landscape, small tablets)
              } else if (constraints.maxWidth < 1200) {
                crossAxisCount = 3; // For larger tablets
              }
              
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20, // Espacio horizontal entre tarjetas
                mainAxisSpacing: 12.8, // Espacio vertical entre tarjetas
                shrinkWrap: true,
                childAspectRatio: 3.1,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  StatCard(
                    title: 'Estudiantes',
                    value: '1,250',
                    icon: Icons.school,
                    color: AppStyles.primaryBlue,
                  ),
                  StatCard(
                    title: 'Profesores',
                    value: '75',
                    icon: Icons.person,
                    color: Colors.orange,
                  ),
                  StatCard(
                    title: 'Materias',
                    value: '32',
                    icon: Icons.book,
                    color: Colors.green,
                  ),
                  StatCard(
                    title: 'Grados',
                    value: '12',
                    icon: Icons.grade,
                    color: Colors.purple,
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 30),
          
          // Tablas de datos recientes con diseño responsivo
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                // Stack the tables vertically on smaller screens
                return Column(
                  children: [
                    DataTableWidget(
                      title: 'Estudiantes Recientes',
                      columns: ['ID', 'Nombre', 'Grado', 'Sección', 'Estado'],
                      data: recentStudents,
                      onRowTap: (student) {
                        // Implementar acción al hacer clic en un estudiante
                      },
                    ),
                    const SizedBox(height: 20),
                    DataTableWidget(
                      title: 'Profesores Recientes',
                      columns: ['ID', 'Nombre', 'Especialidad', 'Estado'],
                      data: recentTeachers,
                      onRowTap: (teacher) {
                        // Implementar acción al hacer clic en un profesor
                      },
                    ),
                  ],
                );
              } else {
                // Side by side on larger screens
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DataTableWidget(
                        title: 'Estudiantes Recientes',
                        columns: ['ID', 'Nombre', 'Grado', 'Sección', 'Estado'],
                        data: recentStudents,
                        onRowTap: (student) {
                          // Implementar acción al hacer clic en un estudiante
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DataTableWidget(
                        title: 'Profesores Recientes',
                        columns: ['ID', 'Nombre', 'Especialidad', 'Estado'],
                        data: recentTeachers,
                        onRowTap: (teacher) {
                          // Implementar acción al hacer clic en un profesor
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          
          const SizedBox(height: 30),
          
          // Gráfico de ejemplo (representado como un contenedor) con ajuste responsivo
          Container(
            height: 300,
            decoration: AppStyles.cardDecoration,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rendimiento Académico',
                  style: AppStyles.dashboardTitleStyle,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Text(
                      'Aquí iría un gráfico de rendimiento académico',
                      style: AppStyles.dashboardSubtitleStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}