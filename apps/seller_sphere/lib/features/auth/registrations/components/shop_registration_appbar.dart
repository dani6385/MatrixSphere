import 'package:flutter/material.dart';

class ShopRegistrationAppBar extends StatefulWidget {
  const ShopRegistrationAppBar({super.key, required Text title});

  @override
  State<ShopRegistrationAppBar> createState() => _ShopRegistrationAppBarState();
}

class _ShopRegistrationAppBarState extends State<ShopRegistrationAppBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Toko Baru'),
      ),
      body: const Center(child: Text('Isi form registrasi toko di sini')),
    );
  }
}