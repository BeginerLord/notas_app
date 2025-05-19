import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/screens/Dashboard/dashboard_home.dart';
import 'package:notas_academicas/src/screens/Dashboard/student_screen.dart';
import 'package:notas_academicas/src/screens/Dashboard/professor_screen.dart';
import 'package:notas_academicas/src/widgets/dashboard/admin_appbar.dart';
import 'package:notas_academicas/src/widgets/dashboard/admin_sidebar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Títulos para cada sección
  final List<String> _sectionTitles = [
    'Dashboard',
    'Estudiantes',
    'Profesores',
    'Materias',
    'Grados',
    'Secciones',
    'Notas',
    'Configuración',
  ];

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos en una pantalla pequeña
    final isSmallScreen = MediaQuery.of(context).size.width < 1200;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppStyles.lightGrey,
      appBar: isSmallScreen
          ? AdminAppBar(
              title: _sectionTitles[_selectedIndex],
              onMenuPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            )
          : null,
      drawer: isSmallScreen
          ? Drawer(
              child: AdminSidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Sidebar (visible solo en pantallas grandes)
          if (!isSmallScreen)
            AdminSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          
          // Contenido principal
          Expanded(
            child: Column(
              children: [
                // AppBar personalizado (visible solo en pantallas grandes)
                if (!isSmallScreen)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: AppStyles.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _sectionTitles[_selectedIndex],
                          style: AppStyles.dashboardTitleStyle,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: AppStyles.black,
                              ),
                              onPressed: () {
                                // Implementar búsqueda
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.notifications,
                                color: AppStyles.black,
                              ),
                              onPressed: () {
                                // Implementar notificaciones
                              },
                            ),
                            const SizedBox(width: 10),
                            const CircleAvatar(
                              backgroundColor: AppStyles.skyBlue,
                              child: Icon(
                                Icons.person,
                                color: AppStyles.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                
                // Contenido de la sección seleccionada
                Expanded(
                  child: _getSelectedScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardHome();
      case 1:
        return const StudentsScreen();
      case 2:
        return const ProfessorScreen();
      case 3:
        return _buildPlaceholderScreen('Gestión de Materias');
      case 4:
        return _buildPlaceholderScreen('Gestión de Grados');
      case 5:
        return _buildPlaceholderScreen('Gestión de Secciones');
      case 6:
        return _buildPlaceholderScreen('Gestión de Notas');
      case 7:
        return _buildPlaceholderScreen('Configuración');
      default:
        return const DashboardHome();
    }
  }

  Widget _buildPlaceholderScreen(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80,
            color: AppStyles.primaryBlue,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppStyles.titleStyle,
          ),
          const SizedBox(height: 10),
          Text(
            'Esta sección está en construcción',
            style: AppStyles.dashboardSubtitleStyle,
          ),
        ],
      ),
    );
  }
}
