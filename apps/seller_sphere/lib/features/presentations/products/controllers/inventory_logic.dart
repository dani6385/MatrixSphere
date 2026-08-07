import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // For Product and ProductService
import 'package:logger/logger.dart';

final Logger _logger = Logger();


class InventoryLogic {
  final ProductService _productService = ProductService();

  /// Menampilkan dialog untuk memperbarui stok produk.
  /// Mengembalikan true jika stok berhasil diperbarui, false jika gagal, atau null jika dibatalkan.
  Future<bool?> showStockUpdateDialog(BuildContext context, Product product) async {
    final TextEditingController stockController =
        TextEditingController(text: product.stock.toString());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Perbarui Stok ${product.name}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Stok Baru',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Stok tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Masukkan angka yang valid';
                }
                if (int.parse(value) < 0) {
                  return 'Stok tidak boleh negatif';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop(null); // Return null if cancelled
              },
            ),
            ElevatedButton(
              child: const Text('Perbarui'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final int newStock = int.parse(stockController.text);
                  try {
                    // Buat objek produk baru dengan stok yang diperbarui
                    final updatedProduct = product.copyWith(stock: newStock);
                    await _productService.updateProduct(updatedProduct);
                    if (dialogContext.mounted) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text('Stok ${product.name} berhasil diperbarui!')),
                      );
                      Navigator.of(dialogContext).pop(true); // Return true if successful
                    }
                  } catch (e) {
                    _logger.i('Error updating stock: $e');
                    if (dialogContext.mounted) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text('Gagal memperbarui stok: $e')),
                      );
                      Navigator.of(dialogContext).pop(false); // Return false if failed
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}