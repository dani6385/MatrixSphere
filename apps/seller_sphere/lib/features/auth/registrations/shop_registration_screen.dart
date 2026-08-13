
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

class ShopRegistrationScreen extends StatefulWidget {
  const ShopRegistrationScreen({super.key});

  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}
class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final ShopRegistrationLogic _logic = ShopRegistrationLogic();
  final ShopRegistrationState _state = ShopRegistrationState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        context.go(AppRoutes.login);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrasi Toko Baru'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _state.formKey,
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
                  controller: _state.shopNameController,
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
                  controller: _state.shopAddressController,
                  decoration: const InputDecoration(labelText: 'Alamat Toko'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat toko tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _state.phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon Toko'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Masukkan nomor telepon yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _state.isLoading
                      ? null
                      : () => _logic.registerShop(
                            context: context,
                            state: _state,
                            onUpdate: () => setState(() {
                              _state.isLoading = !_state.isLoading;
                            }),
                          ),
                  child: _state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Daftarkan Toko'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
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
        ),
      ),
    );
  }
}

class ShopRegistrationLogic {
  Future<void> registerShop({
    required BuildContext context,
    required ShopRegistrationState state,
    required VoidCallback onUpdate,
  }) async {
    if (state.formKey.currentState!.validate()) {
      onUpdate(); // Set isLoading to true

      try {
        // Simulate API call for shop registration
        await Future.delayed(const Duration(seconds: 2));

        // In a real application, you would send data to your backend here
        // final response = await _apiService.registerShop(
        //   shopName: state.shopNameController.text,
        //   shopAddress: state.shopAddressController.text,
        //   phoneNumber: state.phoneNumberController.text,
        // );

        // For demonstration, assume success
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Registrasi toko berhasil! Silakan login.')),
          );
          context.go(AppRoutes.login);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registrasi toko gagal: $e')),
          );
        }
      } finally {
        onUpdate(); // Set isLoading back to false
      }
    }
  }
}

class ShopRegistrationState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  void dispose() {
    shopNameController.dispose();
    shopAddressController.dispose();
    phoneNumberController.dispose();
  }
}