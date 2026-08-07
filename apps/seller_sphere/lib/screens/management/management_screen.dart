// lib/screens/management/management_screen.dart

import 'package:flutter/material.dart';
import 'components/cashier_body.dart';
import 'components/management_drawer.dart';
import 'logic/cashier_logic.dart';

/// Layar utama untuk fitur manajemen, seperti kasir.
class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  // Logic di-handle di sini agar state tetap terjaga
  final CashierLogic _cashierLogic = CashierLogic();

  void _onStateChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _cashierLogic.init(_onStateChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir'),
        centerTitle: true,
      ),
      drawer: const ManagementDrawer(),
      body: CashierBody(cashierLogic: _cashierLogic, onStateChanged: _onStateChanged),
    );
  }
}