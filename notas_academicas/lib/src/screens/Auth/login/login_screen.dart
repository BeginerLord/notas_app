import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notas_academicas/src/hooks/Auth/use_login.dart';
import 'package:notas_academicas/src/providers/auth_provider.dart';
import 'package:notas_academicas/src/providers/query_provider.dart';
import 'package:notas_academicas/src/screens/Auth/login/login_styles.dart';
import 'package:notas_academicas/src/widgets/Auth/custom_text_field.dart';
import 'package:notas_academicas/src/widgets/Auth/primary_button.dart';

class LoginScreen extends HookConsumerWidget {
  const  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(
      authServiceProvider,
    ); // Obtén el servicio como IauthService
    final useLogin = UseLogin(
      ref,
      authService,
    ); // Hook personalizado para login
    final queryState = ref.watch(queryProvider);

    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final isPasswordVisible = ValueNotifier<bool>(false);

    // Método para manejar el inicio de sesión
    Future<void> signIn() async {
      if (!formKey.currentState!.validate()) {
        return;
      }

      await useLogin.login(emailController.text, passwordController.text);

      // Si el login es exitoso, navega a la pantalla principal
      if (context.mounted && queryState.data != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(LoginStyles.kScreenPaddingMedium),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  const Icon(
                    Icons.school_rounded,
                    size: 80,
                    color: LoginStyles.kSoftBlue,
                  ),
                  const SizedBox(height: LoginStyles.kSpacingMedium),
                  const Text(
                    'Notas Académicas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: LoginStyles.kHeadingSize,
                      fontWeight: FontWeight.bold,
                      color: LoginStyles.kSoftBlue,
                    ),
                  ),
                  const SizedBox(height: LoginStyles.kSpacingLarge),

                  // Email Field
                  CustomTextField(
                    controller: emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    errorText:
                        null, // Puedes manejar errores aquí si es necesario
                  ),
                  const SizedBox(height: LoginStyles.kSpacingMedium),

                  CustomTextField(
                    controller: passwordController,
                    label: 'Contraseña',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword:
                        !isPasswordVisible
                            .value, // Aquí se usa el valor actual de isPasswordVisible
                    errorText: null,
                    suffixIcon: ValueListenableBuilder<bool>(
                      valueListenable: isPasswordVisible,
                      builder:
                          (context, isVisible, child) => IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              isPasswordVisible.value =
                                  !isVisible; // Cambia el valor de isPasswordVisible
                            },
                          ),
                    ),
                  ),

                  const SizedBox(height: LoginStyles.kSpacingLarge),

                  // Login Button
                  PrimaryButton(
                    text: 'Iniciar Sesión',
                    onPressed: queryState.isLoading ? () {} : () => signIn(),
                    isLoading: queryState.isLoading,
                    isDisabled: queryState.isLoading,
                  ),
                  const SizedBox(height: LoginStyles.kSpacingMedium),

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
          ),
        ),
      ),
    );
  }
}
