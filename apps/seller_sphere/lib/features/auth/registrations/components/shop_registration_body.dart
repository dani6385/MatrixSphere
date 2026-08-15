import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import '../logics/shop_registration_logic.dart';
import '../states/shop_registration_state.dart';

class ShopRegistrationBody extends StatelessWidget {
  const ShopRegistrationBody({
    super.key,
    required this.state,
    required this.logic,
    required this.onUpdate,
  });

  final ShopRegistrationState state;
  final ShopRegistrationLogic logic;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: state.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Daftarkan toko Anda untuk mulai berjualan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: state.shopNameController,
              decoration: const InputDecoration(labelText: 'Nama Toko'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama toko tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: state.shopAddressController,
              decoration: const InputDecoration(labelText: 'Alamat Toko'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat toko tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => logic.registerShop(
                        context: context,
                        state: state,
                        onUpdate: onUpdate,
                      ),
              child: state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Daftar Toko'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );
                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                context.pop();
                context.go(AppRoutes.login);
              },
              child: const Text('Kembali ke Login'),
            ),
          ],
        ),
      ),
    );
  }
}