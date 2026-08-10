// lib/screens/login/widgets/login_body.dart
import 'package:flutter/material.dart';
import 'login_header.dart';
import 'login_form_fields.dart';

class LoginBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool rememberMe;
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLoginPressed;

  const LoginBody({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.rememberMe,
    required this.onTogglePasswordVisibility,
    required this.onRememberMeChanged,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: AutofillGroup(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const SizedBox(height: 40),
                LoginFormFields(
                  emailController: emailController,
                  passwordController: passwordController,
                  isPasswordVisible: isPasswordVisible,
                  rememberMe: rememberMe,
                  onTogglePasswordVisibility: onTogglePasswordVisibility,
                  onRememberMeChanged: onRememberMeChanged,
                  onLoginPressed: onLoginPressed,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: onLoginPressed,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}