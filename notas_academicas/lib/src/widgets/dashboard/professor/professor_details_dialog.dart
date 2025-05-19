import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/hooks/Professor/index.dart';

class ProfessorDetailsDialog extends ConsumerWidget {
  final Map<String, dynamic> teacher;
  final VoidCallback onDeleted;

  const ProfessorDetailsDialog({
    super.key,
    required this.teacher,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteHook = UseDeleteProfessor(ref);

    return AlertDialog(
      title: const Text('Detalles del Profesor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: teacher.entries.map((e) => Text('${e.key}: ${e.value}')).toList(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),

        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await deleteHook.deleteProfessor(teacher['ID']);
              onDeleted();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profesor eliminado correctamente'), backgroundColor: Colors.green),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al eliminar profesor: $e'), backgroundColor: Colors.red),
              );
            }
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Eliminar'),
        ),

        ElevatedButton(
          onPressed: () {
            // Navegar a edición...
            Navigator.pop(context);
          },
          style: AppStyles.primaryButtonStyle,
          child: const Text('Editar'),
        ),
      ],
    );
  }
}
