
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'dart:math';
import '../states/shop_registration_state.dart';

class ShopRegistrationLogic {
  Future<void> registerShop({
    required BuildContext context,
    required ShopRegistrationState state,
    required VoidCallback onUpdate,
  }) async {
    if (state.formKey.currentState?.validate() ?? false) {
      onUpdate(); // Set isLoading to true

      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));

      // For demonstration, simulate registration success/failure
      // In a real app, you would call an API here
      bool registrationSuccess = Random().nextBool();

      if (registrationSuccess) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi toko berhasil!')),
        );
        context.go(AppRoutes.login); // Navigate to login after successful registration
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi toko gagal. Silakan coba lagi.')),
        );
      }
      onUpdate(); // Set isLoading to false
    }
  }
}
