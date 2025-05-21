import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/hooks/Professor/index.dart';
import 'package:notas_academicas/src/models/professor_model.dart';
import 'package:notas_academicas/src/widgets/Auth/custom_text_field.dart';

class ProfessorUpdateDialog extends HookConsumerWidget {
  final Professor professor;

  const ProfessorUpdateDialog({super.key, required this.professor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllers para los campos del formulario
    final usernameController = useTextEditingController(
      text: professor.username,
    );
    final emailController = useTextEditingController(
      text: professor.email ?? '',
    );
    final passwordController = useTextEditingController();  // Añadido: controller para contraseña
    final telefonoController = useTextEditingController(
      text: professor.telefono,
    );
    final especialidadController = useTextEditingController(
      text: professor.especialidad,
    );
    
    // Estado para controlar la visibilidad de la contraseña
    final isPasswordVisible = useState(false);  // Añadido: estado para visibilidad de contraseña

    // Estados para manejar la validación y carga
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Hook para actualizar profesor
    final updateProfessorHook = UseUpdateProfessor(ref);

    // Función para actualizar profesor
    Future<void> updateProfessor() async {
      if (!formKey.currentState!.validate()) return;

      try {
        isLoading.value = true;
        errorMessage.value = null;

        final uuid = professor.uuid;
        final username = usernameController.text;
        final email = emailController.text;
        final password = passwordController.text;  // Añadido: obtener valor de contraseña
        final telefono = telefonoController.text;
        final especialidad = especialidadController.text;

        // Llamada al hook para actualizar profesor
        await updateProfessorHook.updateProfessor(
          uuid!, // Asegúrate de que uuid no sea null
          professor.copyWith(
            username: username,
            email: email,
            password: password.isNotEmpty ? password : null,  // Añadido: incluir contraseña solo si no está vacía
            telefono: telefono,
            especialidad: especialidad,
          ),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profesor actualizado exitosamente'),
              backgroundColor: AppStyles.primaryBlue,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

    return AlertDialog(
      title: Text('Actualizar Profesor', style: AppStyles.titleStyle),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
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

                // ID no editable
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fingerprint, color: AppStyles.navyBlue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ID',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              professor.uuid ?? 'Sin ID',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Nombre de Usuario',
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre de usuario';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  label: 'Correo Electrónico',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un correo electrónico';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  label: 'Contraseña (dejar vacío para mantener la actual)',
                  controller: passwordController,
                  isPassword: true,
                  isPasswordVisible: isPasswordVisible.value,
                  onTogglePasswordVisibility: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  label: 'Teléfono',
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un número de teléfono';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  label: 'Especialidad',
                  controller: especialidadController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una especialidad';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed:
              isLoading.value ? null : () => Navigator.pop(context, false),
          child: Text('Cancelar', style: TextStyle(color: AppStyles.navyBlue)),
        ),
        ElevatedButton(
          onPressed: isLoading.value ? null : updateProfessor,
          style: AppStyles.primaryButtonStyle,
          child:
              isLoading.value
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Text('Actualizar'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppStyles.white,
      elevation: 5,
    );
  }
}