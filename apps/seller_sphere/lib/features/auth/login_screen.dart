
import 'package:flutter/material.dart';
import 'widgets/login_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      debugPrint('Mencoba login dengan Email: $email, Password: $password, Remember Me: $_rememberMe');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logika login belum diimplementasikan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: LoginBody(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        isPasswordVisible: _isPasswordVisible,
        rememberMe: _rememberMe,
        onTogglePasswordVisibility: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
        onRememberMeChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _rememberMe = newValue;
            });
          }
        },
        onLoginPressed: _login,
      ),
    );
  }
}