import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // Tambahkan ini
import 'package:go_router/go_router.dart'; // Tambahkan ini
import 'package:seller_sphere/navigations/app_routes.dart'; // Tambahkan ini
import 'widgets/login_body.dart';
import 'widgets/login_form_fields.dart';
//import 'widgets/login_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService(); // Gunakan AuthService
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
    // Periksa status login menggunakan AuthService (Firebase)
    final isLoggedIn = _authService.isLoggedIn();
    if (isLoggedIn) {
      // Jika sudah login, arahkan ke halaman utama atau dashboard
      if (kDebugMode) {
        print('User is already logged in via Firebase. Navigating via GoRouter.');
      }
      if (!mounted) return;
      // Gunakan GoRouter untuk navigasi, ini akan memicu logika redirect di app_router.dart
      context.go(AppRoutes.home);
    } else {
      // Jika belum login, tampilkan form login
      setState(() {
        // Pastikan _isLoading diatur ke false agar UI login ditampilkan
        _isLoading = false;
      });
    }
  }

  Future<void> _login(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Gunakan AuthService untuk login sebenarnya dengan Firebase
      await _authService.login(email, password);

      if (kDebugMode) {
        print('Login successful! Firebase user authenticated.');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      // Gunakan GoRouter untuk navigasi, ini akan memicu logika redirect di app_router.dart
      context.go(AppRoutes.home);
    } on Exception catch (e) { // Tangkap Exception spesifik dari AuthService
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString().replaceAll("Exception: ", "")}')),
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
              //const LoginHeader(),
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
