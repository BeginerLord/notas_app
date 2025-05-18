import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notas_academicas/src/models/professor_model.dart';
import 'package:notas_academicas/src/models/student_model.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/widgets/Signup/student_form.dart';
import 'package:notas_academicas/src/widgets/Signup/teacher_form.dart';
// Importar los hooks
import 'package:notas_academicas/src/hooks/Student/index.dart';
import 'package:notas_academicas/src/hooks/Professor/index.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  bool _isStudent = true;

  Future<void> _handleStudentSubmit(Map<String, String> data) async {
    final student = Student(
      username: data['username']!,
      email: data['email']!,
      password: data['password']!,
      acudiente: data['acudiente']!,
      direccion: data['direccion']!,
      telefono: data['telefono']!,
    );

    try {
      // Usar la extensión correctamente
      await context.useCreateStudent.createStudent(student);
      
      // Verificar si el widget todavía está montado
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro de estudiante exitoso!'),
          backgroundColor: AppStyles.primaryBlue,
        ),
      );
      
      // Navegar a login después del registro exitoso
      Navigator.pushReplacementNamed(context, '/login');
    } catch (_) {
      // El hook ya muestra el Toast de error
    }
  }

  Future<void> _handleTeacherSubmit(Map<String, String> data) async {
    final professor = Professor(
      username: data['nombre']!,
      email: data['email']!,
      password: data['password']!,
      especialidad: data['especialidad']!,
      telefono: data['telefono']!,
      // si tu modelo tiene más campos, mapealos aquí
    );

    try {
      // Usar la extensión correctamente
      await context.useCreateProfessor.createProfessor(professor);
      
      // Verificar si el widget todavía está montado
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro de profesor exitoso!'),
          backgroundColor: AppStyles.primaryBlue,
        ),
      );
      
      // Navegar a login después del registro exitoso
      Navigator.pushReplacementNamed(context, '/login');
    } catch (_) {
      // El hook ya muestra el Toast de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppStyles.skyBlue, AppStyles.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset('lib/src/assets/icon.png', height: 100),
                const SizedBox(height: 20),
                Text('Bienvenido',
                    style: AppStyles.titleStyle.copyWith(fontSize: 30),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text('Crea una cuenta para continuar',
                    style: AppStyles.subtitleStyle,
                    textAlign: TextAlign.center),
                const SizedBox(height: 30),
                // Selector Estudiante/Profesor
                Container(
                  decoration: BoxDecoration(
                    color: AppStyles.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.withAlpha((0.3 * 27).toInt()), spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isStudent = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: _isStudent ? AppStyles.primaryBlue : AppStyles.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                            ),
                            child: Text('Estudiante',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _isStudent ? AppStyles.white : AppStyles.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isStudent = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: !_isStudent ? AppStyles.primaryBlue : AppStyles.white,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            child: Text('Profesor',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: !_isStudent ? AppStyles.white : AppStyles.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Formulario acorde
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppStyles.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.withAlpha((0.3 * 27).toInt()), spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: _isStudent
                      ? StudentForm(onSubmit: _handleStudentSubmit)
                      : TeacherForm(onSubmit: _handleTeacherSubmit),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes una cuenta?', style: TextStyle(color: AppStyles.black)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Iniciar Sesión',
                          style: TextStyle(color: AppStyles.primaryBlue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}