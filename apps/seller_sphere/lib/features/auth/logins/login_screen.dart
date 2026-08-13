// lib/features/auth/login/login_screen.dart
import 'package:flutter/material.dart';
import 'package:seller_sphere/widgets/logo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'states/login_state.dart';
import 'logics/login_logic.dart';
import 'widgets/login_body.dart';
import 'widgets/login_form_fields.dart';
import 'widgets/login_header.dart';
import 'widgets/login_loading_body.dart';
import 'widgets/login_social_buttons.dart'; // <-- Import widget sosial media baru

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginLogic _loginLogic = LoginLogic();
  late final LoginState _loginState;

  // Inisialisasi penyimpanan secure storage
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loginState = LoginState(
      isLoading: true,
      isPasswordVisible: false,
      rememberMe: false,
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      formKey: GlobalKey<FormState>(),
    );

    _loadSavedCredentialsAndInitSession();
  }

  @override
  void dispose() {
    _loginState.emailController.dispose();
    _loginState.passwordController.dispose();
    super.dispose();
  }

  void _loadSavedCredentialsAndInitSession() async {
    // Membaca kredensial dari penyimpanan lokal yang aman
    String? email = await _secureStorage.read(key: 'saved_email');
    String? password = await _secureStorage.read(key: 'saved_password');

    // Jika data ditemukan, masukkan kembali ke form controller
    if (email != null && password != null) {
      if (mounted) {
        setState(() {
          _loginState.emailController.text = email;
          _loginState.passwordController.text = password;
          _loginState.rememberMe = true;
        });
      }
    }

    // Melanjutkan inisialisasi sesi login
    _loginLogic.initSession(
      setLoading: (loading) => setState(() => _loginState.isLoading = loading),
      onLoggedIn: () {
        if (!mounted) return;
      },
    );
  }

  void _handleLoginPressed() {
    if (_loginState.formKey.currentState?.validate() ?? false) {
      _loginLogic.login(
        email: _loginState.emailController.text.trim(),
        password: _loginState.passwordController.text,
        rememberMe: _loginState.rememberMe,
        context: context,
        setLoading: (loading) =>
            setState(() => _loginState.isLoading = loading),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loginState.isLoading) {
      return const LoginLoadingBody();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LoginHeader(),
              const Logo(),
              LoginBody(
                onLogin: _handleLoginPressed,
                formFields: LoginFormFields(
                  formKey: _loginState.formKey,
                  isLoading: _loginState.isLoading,
                  emailController: _loginState.emailController,
                  passwordController: _loginState.passwordController,
                  isPasswordVisible: _loginState.isPasswordVisible,
                  rememberMe: _loginState.rememberMe,
                  onLoginPressed: _handleLoginPressed,
                  onTogglePasswordVisibility: () {
                    setState(() {
                      _loginState.isPasswordVisible =
                          !_loginState.isPasswordVisible;
                    });
                  },
                  onRememberMeChanged: (bool? value) {
                    setState(() {
                      _loginState.rememberMe = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              const LoginSocialButtons(), // <-- Menggunakan widget terpisah di sini
            ],
          ),
        ),
      ),
    );
  }
}
