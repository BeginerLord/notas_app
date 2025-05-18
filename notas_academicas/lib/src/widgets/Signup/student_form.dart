import 'package:flutter/material.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'custom_text_field.dart';

class StudentForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const StudentForm({super.key, required this.onSubmit});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _acudienteController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _acudienteController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final studentData = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'acudiente': _acudienteController.text,
        'direccion': _direccionController.text,
        'telefono': _telefonoController.text,
      };
      widget.onSubmit(studentData);
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
            'Registro de Estudiante',
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
            label: 'Acudiente',
            icon: Icons.person_outline,
            controller: _acudienteController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa el nombre del acudiente';
              }
              return null;
            },
          ),
          CustomTextField(
            label: 'Dirección',
            icon: Icons.home,
            controller: _direccionController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una dirección';
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
