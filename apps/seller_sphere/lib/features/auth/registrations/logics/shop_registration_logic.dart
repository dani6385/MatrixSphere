
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:shared_services/shared_services.dart';

import '../states/shop_registration_state.dart';

class ShopRegistrationLogic {
  final ShopService _shopService = ShopService();
  final LocationService _locationService = LocationService();

  Future<void> registerShop({
    required BuildContext context,
    required ShopRegistrationState state,
    required VoidCallback onUpdate,
  }) async {
    if (state.formKey.currentState?.validate() ?? false) {
      state.setIsLoading(true);
      onUpdate();

      try {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception('Pengguna tidak login. Silakan login terlebih dahulu.');
        }

        final position = await _locationService.getCurrentLocation();
        final coordinates = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };

        await _shopService.registerShop(
          user: user,
          shopName: state.shopNameController.text,
          fullAddress: state.addressController.text,
          coordinates: coordinates,
        );

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi toko berhasil! Menunggu persetujuan admin.'),
            backgroundColor: Colors.green,
          ),
        );
        context.go(AppRoutes.login);
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi toko gagal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        state.setIsLoading(false);
        onUpdate();
      }
    }
  }
}
