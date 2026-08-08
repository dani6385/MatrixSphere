// lib/screens/products/public_product_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'widgets/product_list.dart';

/// Layar untuk menampilkan ringkasan stok produk di gudang.
/// Mengambil data secara real-time dari Firebase menggunakan ProductService.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // Instance dari ProductService untuk berinteraksi dengan database.
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
      ),
      body: ProductList(
        productsStream: _productService.getProductsStream(),
        
      ),
      // Tombol untuk menambah produk baru
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-product'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
