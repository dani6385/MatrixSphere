
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:shared_services/shared_services.dart';

class RegistrationLogic {
  final AuthService _authService = AuthService();

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
    required Function(bool) setLoading,
  }) async {
    setLoading(true);
    try {
      await _authService.registerUser(
        name: name,
        email: email,
        password: password,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
        );
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal: $e')),
        );
      }
    } finally {
      setLoading(false);
    }
  }
}
