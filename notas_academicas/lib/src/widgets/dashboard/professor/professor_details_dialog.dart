import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/hooks/Professor/index.dart';
import 'package:notas_academicas/src/models/professor_model.dart';
import 'package:notas_academicas/src/widgets/dashboard/professor/professor_update_dialog.dart';

class ProfessorDetailsDialog extends HookConsumerWidget {
  final Map<String, dynamic> teacher;
  final Function onDeleted;
  
  const ProfessorDetailsDialog({
    super.key, 
    required this.teacher,
    required this.onDeleted,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    
    // Hook para eliminar profesor
    final deleteHook = UseDeleteProfessor(ref);
    
    // Función para eliminar profesor
    Future<void> deleteProfessor() async {
      final uuid = teacher['ID'] as String;
      if (uuid.isEmpty) {
        errorMessage.value = 'ID de profesor no válido';
        return;
      }
      
      // Confirmar eliminación
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar al profesor ${teacher['Nombre']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      
      if (confirmed != true) return;
      
      try {
        isLoading.value = true;
        errorMessage.value = null;
        
        await deleteHook.deleteProfessor(uuid);
        
        if (context.mounted) {
          Navigator.pop(context); // Cerrar el diálogo de detalles
          onDeleted(); // Llamar a la función de recarga
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
    
    // Función para editar profesor
    Future<void> editProfessor() async {
      final uuid = teacher['ID'] as String;
      if (uuid.isEmpty) {
        errorMessage.value = 'ID de profesor no válido';
        return;
      }
      
      // Crear objeto Professor a partir del Map
      final professor = Professor(
        uuid: uuid,
        username: teacher['Nombre'] as String,
        email: teacher['Email'] as String,
        telefono: teacher['Teléfono'] as String,
        especialidad: teacher['Especialidad'] as String,
      );
      
      // Cerrar este diálogo y abrir el de edición
      Navigator.pop(context);
      
      final updated = await showDialog<bool>(
        context: context,
        builder: (_) => ProfessorUpdateDialog(professor: professor),
      );
      
      if (updated == true) {
        onDeleted(); // Recargar datos después de actualización
      }
    }
    
    return AlertDialog(
      title: Text('Detalles del Profesor', style: AppStyles.titleStyle),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (errorMessage.value != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    errorMessage.value!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              
              _buildInfoItem(Icons.person, 'Nombre', teacher['Nombre'] ?? 'N/D'),
              _buildInfoItem(Icons.email, 'Email', teacher['Email'] ?? 'N/D'),
              _buildInfoItem(Icons.school, 'Especialidad', teacher['Especialidad'] ?? 'N/D'),
              _buildInfoItem(Icons.phone, 'Teléfono', teacher['Teléfono'] ?? 'N/D'),
              _buildInfoItem(Icons.verified_user, 'Estado', teacher['Estado'] ?? 'N/D'),
              _buildInfoItem(Icons.fingerprint, 'ID', teacher['ID'] ?? 'N/D'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading.value ? null : () => Navigator.pop(context),
          child: Text('Cerrar', style: TextStyle(color: AppStyles.navyBlue)),
        ),
        ElevatedButton(
          onPressed: isLoading.value ? null : editProfessor,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.primaryBlue,
          ),
          child: const Text('Editar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: isLoading.value ? null : deleteProfessor,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Eliminar', style: TextStyle(color: Colors.white)),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppStyles.white,
      elevation: 5,
    );
  }
  
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppStyles.navyBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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