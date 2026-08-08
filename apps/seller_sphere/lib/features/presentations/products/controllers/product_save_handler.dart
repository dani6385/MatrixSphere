// lib/features/products/presentation/controllers/product_save_handler.dart

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_services/shared_services.dart';

final Logger _logger = Logger();

class ProductSaveHandler {
  final ProductService _productService = ProductService();
  final ImageUploadService _imageUploadService = ImageUploadService();

  /// Menyimpan atau memperbarui produk ke database
  Future<void> saveProduct({
    required BuildContext context,
    required bool isEditMode,
    String? productId,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required TextEditingController priceController,
    required TextEditingController skuController,
    required TextEditingController purchasePriceController,
    required TextEditingController itemCountController,
    required String? existingImageUrl,
    required XFile? selectedImageFile,
    required ValueNotifier<bool> isLoading,
  }) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      String imageUrl = existingImageUrl ?? '';
      if (selectedImageFile != null) {
        // Menggunakan service yang aman dan method yang sesuai
        final uploadedUrl = await _imageUploadService
            .uploadImageToImgBB(File(selectedImageFile.path));
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      final priceValue = double.tryParse(priceController.text) ?? 0.0;
      final purchasePriceValue =
          double.tryParse(purchasePriceController.text) ?? 0.0;
      // Default ke 1 untuk menghindari pembagian dengan nol jika input tidak valid
      final itemCountValue = int.tryParse(itemCountController.text) ?? 1;

      // Hitung unitPrice (harga modal per item).
      // Pastikan itemCountValue tidak nol untuk menghindari error pembagian.
      final unitPriceValue = (itemCountValue > 0)
          ? purchasePriceValue / itemCountValue
          : purchasePriceValue;

      // Dapatkan shopId dari user yang sedang login.
      final shopId = AuthService().currentUser?.uid ?? '';

      final product = Product(
        id: isEditMode ? productId! : '',
        shopId: shopId, // Menggunakan ID toko dari pengguna yang sedang login
        name: nameController.text,
        description: descriptionController.text,
        sku: skuController.text.isNotEmpty
            ? skuController.text
            : null, // Menghapus unitPrice yang duplikat
        imageUrl: imageUrl,
        category: '',
        soldCount: 0,
        sellingPrice: priceValue,
        purchasePrice: purchasePriceValue,
        stock: 0, unitPrice: unitPriceValue,
      );

      try {
        if (isEditMode) {
          await _productService.updateProduct(product);
        } else {
          await _productService.addProduct(product);
        }
        if (context.mounted) {
          final successMessage = isEditMode
              ? 'Produk berhasil diperbarui'
              : 'Produk berhasil ditambahkan';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(successMessage)),
          );
          context.pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan produk: $e')),
          );
        }
        _logger.e('Gagal menyimpan produk: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
