import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seller_sphere/core/services/session_manager.dart'; // Sesuaikan path jika perlu
import 'widgets/login_body.dart';
import 'widgets/login_form_fields.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SessionManager _sessionManager = SessionManager();
  bool _isLoading = true; // Tambahkan state untuk loading

  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State for password visibility
  bool _isPasswordVisible = false;

  // State for remember me checkbox
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _initSession() async {
    final isLoggedIn = await _sessionManager.isLoggedIn();
    if (isLoggedIn) {
      // Jika sudah login, arahkan ke halaman utama atau dashboard
      // Contoh: Navigator.of(context).pushReplacementNamed('/home');
      if (kDebugMode) {
        print('User is already logged in. Navigating to home screen.');
      }
      // Untuk demo, kita bisa langsung set isLoading ke false
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulasi proses login
      await Future.delayed(const Duration(seconds: 2));

      // Anggap login berhasil dan kita mendapatkan token
      const String dummyToken = 'your_super_secret_jwt_token_here';
      await _sessionManager.saveSession(dummyToken);

      // Navigasi ke halaman berikutnya setelah login berhasil
      // Contoh: Navigator.of(context).pushReplacementNamed('/home');
      if (kDebugMode) {
        print('Login successful! Token saved.');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      Navigator.of(context)
          .pushReplacementNamed('/home'); // Navigate to home screen
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          // The SingleChildScrollView has one child, which is Padding
          padding: const EdgeInsets.all(16.0),
          // The Column is the child of the Padding widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LoginHeader(),
              LoginBody(
                formFields: LoginFormFields(
                  onLogin: _login,
                  isLoading: _isLoading,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  isPasswordVisible: _isPasswordVisible,
                  rememberMe: _rememberMe,
                  onTogglePasswordVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  onRememberMeChanged: (bool? value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  onLoginPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _login(
                        _emailController.text.trim(),
                        _passwordController.text,
                      );
                    }
                  },
                ),
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
                onRememberMeChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                onLoginPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _login(
                      _emailController.text.trim(),
                      _passwordController.text,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
