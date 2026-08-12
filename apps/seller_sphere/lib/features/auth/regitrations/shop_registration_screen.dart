import 'package:flutter/material.dart';
import 'states/shop_registration_state.dart';
import 'logics/shop_registration_logic.dart';
import 'components/shop_registration_body.dart'; // Import widget body yang baru

class ShopRegistrationScreen extends StatefulWidget {
  const ShopRegistrationScreen({super.key});

  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final ShopRegistrationLogic _logic = ShopRegistrationLogic();

  late final ShopRegistrationState _shopState = ShopRegistrationState(
    formKey: GlobalKey<FormState>(),
    shopNameController: TextEditingController(),
    fullAddressController: TextEditingController(),
  );
  
  // API Key dipindahkan atau tetap di sini sebagai variabel kontrol
  final String _googleApiKey = "AIzaSyCG_oXq8jpOoJeZ9uJ1gfeQ4kDVlTRHK4Q";

  @override
  void initState() {
    super.initState();
    _logic.getCurrentLocation(
      state: _shopState,
      onUpdate: () => setState(() {}),
    );
    _logic.getShopStatus(
      state: _shopState,
      onUpdate: () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _shopState.shopNameController.dispose();
    _shopState.fullAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftarkan Toko Anda'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _shopState.formKey,
          child: ShopRegistrationBody(
            shopState: _shopState,
            logic: _logic,
            googleApiKey: _googleApiKey,
            onUpdate: () => setState(() {}),
          ),
        ),
      ),
    );
  }
}