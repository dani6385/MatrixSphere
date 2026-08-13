import 'package:flutter/material.dart';
import 'logics/shop_registration_logic.dart';
import 'components/shop_registration_body.dart';
import 'states/shop_registration_state.dart';

class ShopRegistrationScreen extends StatefulWidget {
  const ShopRegistrationScreen({super.key});
  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final _state = ShopRegistrationState();
  final _logic = ShopRegistrationLogic();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pendaftaran Toko'), centerTitle: true),
      body: ShopRegistrationBody(state: _state, logic: _logic, onUpdate: () => setState(() {})),
    );
  }
}