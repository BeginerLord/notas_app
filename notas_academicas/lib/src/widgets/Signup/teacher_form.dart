import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'custom_text_field.dart';

class TeacherForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const TeacherForm({super.key, required this.onSubmit});

  @override
  State<TeacherForm> createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _especialidadController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    _especialidadController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final teacherData = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'telefono': _telefonoController.text,
        'especialidad': _especialidadController.text,
      };
      widget.onSubmit(teacherData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text(
            'Registro de Profesor',
            style: AppStyles.titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            label: 'Nombre de Usuario',
            icon: Icons.person,
            controller: _usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa un nombre de usuario';
              }
              return null;
            },
          ),
          CustomTextField(
            label: 'Correo Electrónico',
            icon: Icons.email,
            controller: _emailController,
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
            icon: Icons.lock,
            isPassword: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          CustomTextField(
            label: 'Teléfono',
            icon: Icons.phone,
            controller: _telefonoController,
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
            icon: Icons.school,
            controller: _especialidadController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu especialidad';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            style: AppStyles.primaryButtonStyle,
            child: Text('Registrarse', style: AppStyles.buttonTextStyle),
          ),
        ],
      ),
    );
  }
}
