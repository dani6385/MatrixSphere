import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
//import 'package:shared_ui/shared_ui.dart';

/// Halaman untuk menampilkan daftar semua produk yang tersedia.
///
/// Halaman ini menggunakan StreamBuilder untuk mendengarkan perubahan data produk
/// secara real-time dari Firebase melalui ProductService.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Product>>(
        stream: _productService.getProductsStream(),
        builder: (context, snapshot) {
          // Tampilkan loading indicator saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tampilkan pesan error jika terjadi kesalahan
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          // Tampilkan pesan jika tidak ada data produk
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Belum ada produk yang ditambahkan.'),
            );
          }

          // Jika data tersedia, tampilkan dalam bentuk daftar
          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: product.imageUrl != null
                        ? NetworkImage(product.imageUrl!)
                        : null,
                    child: product.imageUrl == null
                        ? Text(product.name.substring(0, 1).toUpperCase())
                        : null,
                  ),
                  title: Text(product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Stok: ${product.stock}'),
                  trailing: Text(
                    formatCurrency(product.sellingPrice),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}