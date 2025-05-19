import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';

class AdminSidebarItem {
  final String title;
  final IconData icon;
  final int index;

  AdminSidebarItem({
    required this.title,
    required this.icon,
    required this.index,
  });
}

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<AdminSidebarItem> sidebarItems = [
      AdminSidebarItem(
        title: 'Dashboard',
        icon: Icons.dashboard,
        index: 0,
      ),
      AdminSidebarItem(
        title: 'Estudiantes',
        icon: Icons.school,
        index: 1,
      ),
      AdminSidebarItem(
        title: 'Profesores',
        icon: Icons.person,
        index: 2,
      ),
      AdminSidebarItem(
        title: 'Materias',
        icon: Icons.book,
        index: 3,
      ),
      AdminSidebarItem(
        title: 'Grados',
        icon: Icons.grade,
        index: 4,
      ),
      AdminSidebarItem(
        title: 'Secciones',
        icon: Icons.group_work,
        index: 5,
      ),
      AdminSidebarItem(
        title: 'Notas',
        icon: Icons.assignment,
        index: 6,
      ),
      AdminSidebarItem(
        title: 'Configuración',
        icon: Icons.settings,
        index: 7,
      ),
    ];

    return Container(
      width: 250,
      color: AppStyles.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: AppStyles.primaryBlue,
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.school,
                    size: 40,
                    color: AppStyles.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sistema Educativo',
                    style: AppStyles.subtitleStyle.copyWith(
                      color: AppStyles.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Panel de Administración',
                    style: TextStyle(
                      color: AppStyles.white.withAlpha((0.7 * 255).toInt()),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: sidebarItems.length,
              itemBuilder: (context, index) {
                final item = sidebarItems[index];
                final isSelected = selectedIndex == item.index;
                
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppStyles.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? AppStyles.white : AppStyles.primaryBlue,
                    ),
                    title: Text(
                      item.title,
                      style: isSelected
                          ? AppStyles.sidebarSelectedItemStyle
                          : AppStyles.sidebarItemStyle,
                    ),
                    onTap: () => onItemSelected(item.index),
                    selected: isSelected,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppStyles.skyBlue,
                  child: Icon(
                    Icons.person,
                    color: AppStyles.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin User',
                        style: AppStyles.subtitleStyle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'admin@example.com',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppStyles.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: AppStyles.darkGrey,
                  ),
                  onPressed: () {
                    // Implementar lógica de cierre de sesión
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
