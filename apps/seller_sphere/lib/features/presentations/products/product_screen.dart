// lib/features/presentations/products/product_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/product_view_model.dart';
import 'components/product_app_bar.dart';
import 'components/product_body.dart';
import 'components/product_form_screen.dart';

/// Layar utama untuk menampilkan daftar produk, serta fungsi tambah, edit, dan hapus.
class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel(),
      child: Scaffold(
        appBar: const ProductAppBar(products: '',),
        body: const ProductBody(),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProductFormScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}