import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_logics/shared_logics.dart';
//import 'package:shared_services/shared_services.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:shared_ui/shared_ui.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegistrationState _state;
  late final RegistrationLogic _registrationLogic;

  @override
  void initState() {
    super.initState();
    _state = RegistrationState.initial();
    _registrationLogic = RegistrationLogic();
  }

  @override
  void dispose() {
    _state.nameController.dispose();
    _state.emailController.dispose();
    _state.passwordController.dispose();
    _state.confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _state = _state.copyWith(isPasswordVisible: !_state.isPasswordVisible);
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _state = _state.copyWith(
        isConfirmPasswordVisible: !_state.isConfirmPasswordVisible,
      );
    });
  }

  void _register() {
    if (_state.formKey.currentState?.validate() ?? false) {
      _registrationLogic.register(
        name: _state.nameController.text.trim(),
        email: _state.emailController.text.trim(),
        password: _state.passwordController.text.trim(),
        context: context,
        setLoading: (isLoading) {
          if (mounted) {
            setState(() {
              _state = _state.copyWith(isLoading: isLoading);
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _state.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _state.nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _state.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Email tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _state.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _state.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: !_state.isPasswordVisible,
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Password tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _state.confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _state.isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
                obscureText: !_state.isConfirmPasswordVisible,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  if (value != _state.passwordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _state.isLoading ? null : _register,
                child: _state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Daftar'),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Sudah punya akun? ',
                    style: AppStyles.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: context.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.go(AppRoutes.login),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
