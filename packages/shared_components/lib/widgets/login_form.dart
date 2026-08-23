import 'package:flutter/material.dart';
import 'package:shared_logics/shared_logics.dart';

class LoginForm extends StatefulWidget {
  final LoginController controller;

  const LoginForm({super.key, required this.controller});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final ctrl = widget.controller;

    return AutofillGroup(
      child: Form(
        key: ctrl.formKey,
        child: Column(
          children: [
            TextFormField(
              controller: ctrl.emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Email wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: ctrl.passwordController,
              obscureText: ctrl.obscurePassword,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(ctrl.obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => ctrl.obscurePassword = !ctrl.obscurePassword),
                ),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Password wajib diisi' : null,
            ),
            Row(
              children: [
                Checkbox(
                  value: ctrl.rememberMe,
                  onChanged: (v) => setState(() => ctrl.rememberMe = v ?? false),
                ),
                const Text('Ingat Saya'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}