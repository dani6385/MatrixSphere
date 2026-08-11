import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:seller_sphere/features/auth/waiting_for_approval_screen.dart';
import 'package:seller_sphere/navigations/app_navigation.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ShopRegistrationScreen extends StatefulWidget {
  const ShopRegistrationScreen({super.key});

  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _authService = AuthService();
  final _rtdbService = FirebaseRtdbService();

  @override
  void dispose() {
    _shopNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForApproval() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      _showError("Sesi Anda telah berakhir. Silakan login kembali.");
      AppNavigation.goToLogin(context);
      return;
    }

    final shopName = _shopNameController.text.trim();
    final uid = currentUser.uid;

    // Data yang akan dikirim ke node 'approval'
    final approvalData = {
      'nama': shopName,
      'ownerUid': uid,
      'email': currentUser.email,
      'submittedAt': ServerValue.timestamp,
    };

    // Menggunakan FirebaseRtdbService untuk menulis data
    final success = await _rtdbService.writeData('approval/$uid', approvalData);

    if (success && mounted) {
      showInfoDialog(
          context: context,
          title: 'Pendaftaran Terkirim',
          message:
              'Pendaftaran toko "$shopName" telah berhasil dikirim. Mohon tunggu persetujuan dari admin.',
          buttonText: 'OK',
          onPressed: () {
            AppNavigation.goToWaitingForApproval(context);
          });
    } else {
      _showError("Gagal mengirim pendaftaran toko. Silakan coba lagi.");
    }
  }

  void _showError(String message) {
    if (mounted) {
      showErrorDialog(context: context, message: message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi Toko')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Daftarkan toko Anda untuk menunggu persetujuan admin.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _shopNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Toko',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama toko wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForApproval,
                  child: const Text('Ajukan Pendaftaran'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
