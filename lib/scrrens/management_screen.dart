// lib/screens/management/management_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/scrrens/components/management_appbar.dart';
import 'package:shared_services/shared_services.dart';

import 'package:shared_ui/shared_ui.dart';
import 'components/cart_items_list.dart';
import 'components/management_summary_card.dart';

/// Halaman Kasir (Point of Sale)[cite: 12]
class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final List<CartItem> _cartItems = [];
  final ProductService _productService = ProductService();

  Future<void> _handleScannedCode(String productId) async {
    final product = await _productService.getProductById(productId);

    if (product == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk tidak ditemukan.'),
            backgroundColor: kAlertRed,
          ),
        );
      }
      return;
    }

    setState(() {
      final existingIndex =
          _cartItems.indexWhere((item) => item.product.id == product.id);

      if (existingIndex != -1) {
        _cartItems[existingIndex].quantity++;
      } else {
        _cartItems.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  Future<void> _scanProduct() async {
    final scannedCode = await context.push<String>('/scan');

    if (scannedCode != null && scannedCode.isNotEmpty) {
      _handleScannedCode(scannedCode);
    }
  }

  double get _totalPrice {
    return _cartItems.fold(
        0, (total, item) => total + (item.product.sellingPrice * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ManagementAppBarScreen(),
      ),
      body: Column(
        children: [
          // 1. Memanggil komponen daftar keranjang terpisah
          Expanded(
            child: CartItemsList(cartItems: _cartItems),
          ),

          // 2. Memanggil komponen kartu ringkasan & tombol aksi terpisah
          ManagementSummaryCard(
            totalPrice: _totalPrice,
            onScanPressed: _scanProduct,
          ),
        ],
      ),
    );
  }
}