import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notas_academicas/src/hooks/Auth/use_login.dart';
import 'package:notas_academicas/src/app_styles.dart';
import 'package:notas_academicas/src/screens/Auth/login/login_styles.dart';
import 'package:notas_academicas/src/widgets/Auth/custom_text_field.dart';
import 'package:notas_academicas/src/widgets/Auth/primary_button.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Hooks para controlar el formulario
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordVisible = useState<bool>(false);
    final isLoading = useState<bool>(false);
    final errorMessage = useState<String?>(null);

    // Hook de login
    final loginHook = UseLogin(ref);

    // Método para manejar el inicio de sesión
    Future<void> signIn() async {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }

      try {
        isLoading.value = true;
        errorMessage.value = null;

        await loginHook.login(emailController.text, passwordController.text);

        // Verificar si el widget todavía está montado
        if (!context.mounted) return;

        // Navegar a la pantalla principal
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Image.asset('lib/src/assets/icon.png', height: 100),
                    const SizedBox(height: 20),

                    Text(
                      'Bienvenido de Nuevo',
                      style: AppStyles.titleStyle.copyWith(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    Text(
                      'Inicia sesión para continuar',
                      style: AppStyles.subtitleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Formulario de login
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppStyles.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha((0.3 * 27).toInt()),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Email Field
                          CustomTextField(
                            controller: emailController,
                            label: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu email';
                              }
                              if (!value.contains('@')) {
                                return 'Por favor ingresa un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: LoginStyles.kSpacingMedium),

                          // Password Field
                          CustomTextField(
                            controller: passwordController,
                            label: 'Contraseña',
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: !isPasswordVisible.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                isPasswordVisible.value =
                                    !isPasswordVisible.value;
                              },
                            ),
                          ),

                          const SizedBox(height: LoginStyles.kSpacingMedium),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Implementar recuperación de contraseña
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(color: AppStyles.primaryBlue),
                              ),
                            ),
                          ),

                          const SizedBox(height: LoginStyles.kSpacingMedium),

                          // Login Button
                          PrimaryButton(
                            text: 'Iniciar Sesión',
                            onPressed: isLoading.value ? null : signIn,
                            isLoading: isLoading.value,
                            isDisabled: isLoading.value,
                          ),
                        ],
                      ),
                    ),

                    // Error Message
                    if (errorMessage.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          errorMessage.value!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Link a registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿No tienes una cuenta?',
                          style: TextStyle(color: AppStyles.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: const Text(
                            'Regístrate',
                            style: TextStyle(
                              color: AppStyles.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
