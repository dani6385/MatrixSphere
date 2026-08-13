import 'package:flutter/material.dart';
import '../states/shop_registration_state.dart';

class ShopRegistrationLogic {
  Future<void> submitRegistration(BuildContext context, ShopRegistrationState state, Function(bool) setLoading) async {
    if (state.formKey.currentState?.validate() ?? false) {
      setLoading(true);
      
      debugPrint('Mendaftarkan toko: ${state.shopNameController.text}');

      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran Toko Berhasil!')),
        );
      }
    }
  }
}