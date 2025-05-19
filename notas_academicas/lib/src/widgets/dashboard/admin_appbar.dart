import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';


class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuPressed;

  const AdminAppBar({
    super.key,
    required this.title,
    required this.onMenuPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppStyles.white,
      elevation: 0,
      title: Text(
        title,
        style: AppStyles.dashboardTitleStyle,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: AppStyles.black,
        ),
        onPressed: onMenuPressed,
      ),
      actions: [
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
      ],
    );
  }
}
