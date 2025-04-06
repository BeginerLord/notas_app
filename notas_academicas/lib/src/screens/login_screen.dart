import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/hooks/Auth/use_login.dart';
import 'package:notas_academicas/src/services/Auth/implementation/auth_service_impl.dart';
import 'package:notas_academicas/src/api/api_service.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryState = ref.watch(queryProvider); // Observa el estado del queryProvider
    final authService = AuthServiceImpl(Api()); // Instancia del servicio de autenticación
    final useLogin = UseLogin(ref, authService); // Hook personalizado para login

    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Método para manejar el inicio de sesión
    Future<void> signIn() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      await useLogin.login(
        emailController.text,
        passwordController.text,
      );

      // Si el login es exitoso, navega a la pantalla principal
      if (queryState.data != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Soft background color
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or App Name
                const Icon(
                  Icons.school_rounded,
                  size: 80,
                  color: Color(0xFF7B8CDE), // Soft blue color
                ),
                const SizedBox(height: 16),
                const Text(
                  'Academic Manager',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B8CDE), // Soft blue color
                  ),
                ),
                const SizedBox(height: 40),

                // Login Form
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Username Field
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'email',
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF7B8CDE)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF7B8CDE)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      ElevatedButton(
                        onPressed: queryState.isLoading ? null : signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B8CDE), // Soft blue color
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: queryState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Error Message
                      if (queryState.error != null)
                        Text(
                          'Error: ${queryState.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}