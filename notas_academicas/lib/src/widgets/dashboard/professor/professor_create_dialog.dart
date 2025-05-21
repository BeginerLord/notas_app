import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notas_academicas/src/hooks/Professor/index.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/models/professor_model.dart';
import 'package:notas_academicas/src/widgets/Auth/custom_text_field.dart';

class ProfessorCreateDialog extends HookConsumerWidget {
  const ProfessorCreateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Controllers para los campos del formulario
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final telefonoController = useTextEditingController();
    final especialidadController = useTextEditingController();
    
    // Añadido: Estado para la visibilidad de la contraseña
    final isPasswordVisible = useState(false);
    
    // Estados para manejar la validación y carga
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    // Hook para crear profesor
    final createProfessorHook = UseCreateProfessor(ref);

    // Función para crear profesor
    Future<void> createProfessor() async {
      if (!formKey.currentState!.validate()) return;
      
      try {
        isLoading.value = true;
        errorMessage.value = null;
        
        final professor = Professor.create(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
          telefono: telefonoController.text,
          especialidad: especialidadController.text,
        );
        
        // Llamada al hook para crear profesor
        await createProfessorHook.createProfessor(professor);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profesor creado exitosamente'),
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
      title: Text('Crear Profesor', style: AppStyles.titleStyle),
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
                
                CustomTextField(
                  label: 'Nombre Completo',
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
                  label: 'Contraseña',
                  controller: passwordController,
                  isPassword: true,
                  isPasswordVisible: isPasswordVisible.value,
                  onTogglePasswordVisibility: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una contraseña';
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
          onPressed: isLoading.value 
              ? null 
              : () => Navigator.pop(context, false),
          child: Text(
            'Cancelar',
            style: TextStyle(color: AppStyles.navyBlue),
          ),
        ),
        ElevatedButton(
          onPressed: isLoading.value ? null : createProfessor,
          style: AppStyles.primaryButtonStyle,
          child: isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Guardar'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppStyles.white,
      elevation: 5,
    );
  }
}