import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/scrrens/components/items/management_drawer.dart';

import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// Halaman Kasir (Point of Sale)
///
/// Halaman ini berfungsi sebagai antarmuka utama untuk proses transaksi,
/// memungkinkan pengguna untuk memindai produk, melihat item di keranjang,
/// dan menyelesaikan pembayaran.
class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final List<CartItem> _cartItems = [];
  final ProductService _productService = ProductService();

  // Fungsi untuk memproses hasil pindaian (scan)
  Future<void> _handleScannedCode(String productId) async {
    // Cari produk berdasarkan ID yang dipindai
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

    // Tambahkan produk ke keranjang
    setState(() {
      // Cek apakah produk sudah ada di keranjang
      final existingIndex =
          _cartItems.indexWhere((item) => item.product.id == product.id);

      if (existingIndex != -1) {
        // Jika sudah ada, tambahkan jumlahnya
        _cartItems[existingIndex].quantity++;
      } else {
        // Jika belum ada, tambahkan sebagai item baru
        _cartItems.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  // Fungsi untuk memulai proses pemindaian
  Future<void> _scanProduct() async {
    // Navigasi ke halaman scanner dan tunggu hasilnya
    // Pastikan Anda sudah memiliki 'ScannerScreen' dan rute '/scan'
    final scannedCode = await context.push<String>('/scan');

    if (scannedCode != null && scannedCode.isNotEmpty) {
      _handleScannedCode(scannedCode);
    }
  }

  // Menghitung total harga
  double get _totalPrice {
    return _cartItems.fold(
        0, (total, item) => total + (item.product.sellingPrice * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir (POS)'),
        centerTitle: true,
      ),
      // Menambahkan drawer ke Scaffold
      drawer: const ManagementDrwaer(),
      body: Column(
        children: [
          // 1. Daftar Produk di Keranjang
          Expanded(
            child: _cartItems.isEmpty
                ? const Center(
                    child: Text('Pindai produk untuk memulai transaksi.'),
                  )
                : ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: item.product.imageUrl != null
                              ? NetworkImage(item.product.imageUrl!)
                              : null,
                          child: item.product.imageUrl == null
                              ? Text(item.product.name.substring(0, 1))
                              : null,
                        ),
                        title: Text(item.product.name),
                        subtitle: Text(
                            '${item.quantity} x ${formatCurrency(item.product.sellingPrice)}'),
                        trailing: Text(
                          formatCurrency(item.product.sellingPrice * item.quantity),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
          ),

          // 2. Ringkasan dan Tombol Aksi
          _buildSummaryAndActions(),
        ],
      ),
    );
  }

  Widget _buildSummaryAndActions() {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 20)),
                Text(
                  formatCurrency(_totalPrice),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Pindai Produk'),
                    onPressed: _scanProduct,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}