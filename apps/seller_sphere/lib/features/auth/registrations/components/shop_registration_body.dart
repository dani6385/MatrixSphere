import 'package:flutter/material.dart';
import '../logics/shop_registration_logic.dart';
import '../states/shop_registration_state.dart';

class ShopRegistrationBody extends StatelessWidget {
  final ShopRegistrationState state;
  final ShopRegistrationLogic logic;
  final VoidCallback onUpdate;

  const ShopRegistrationBody({super.key, required this.state, required this.logic, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: state.formKey,
        child: Column(
          children: [
            // Masukkan TextFormField di sini seperti kode aslimu, 
            // gunakan state.shopNameController, dst.
            ElevatedButton(
              onPressed: state.isLoading ? null : () => logic.submitRegistration(context, state, (v) { state.isLoading = v; onUpdate(); }),
              child: state.isLoading ? const CircularProgressIndicator() : const Text('Daftarkan'),
            ),
          ],
        ),
      ),
    );
  }
}