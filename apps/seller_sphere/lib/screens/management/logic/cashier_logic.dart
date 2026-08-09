// lib/screens/management/cashier_logic.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import '../widgets/cashier_sort_dropdown.dart';

class CashierLogic {
  final ProductService _productService = ProductService();

  // State data
  final List<CartItem> cartItems = [];
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  ProductSortOption currentSortOption = ProductSortOption.none;
  final TextEditingController searchController = TextEditingController();

  // Getter total amount belanja
  double get totalAmount => cartItems.fold(
      0, (sum, item) => sum + (item.product.sellingPrice * item.quantity));

  double cashPaid = 0.0;
  double get changeAmount =>
      cashPaid > totalAmount ? cashPaid - totalAmount : 0.0;
  bool get isCashValid => cashPaid >= totalAmount;

  void updateCashPaid(String value) {
    cashPaid = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
  }

  Future<void> init(VoidCallback onUpdate) async {
    await fetchProducts(onUpdate);
    searchController.addListener(onUpdate);
  }

  void dispose() {
    searchController.dispose();
  }

  Future<void> fetchProducts(VoidCallback onUpdate) async {
    final products = await _productService.getProducts();
    allProducts = products;
    applyFilterAndSort();
    onUpdate();
  }

  String? addProductToCart(Product product) {
    if (product.stock <= 0) {
      return 'Stok ${product.name} habis!';
    }
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1 && cartItems[index].quantity < product.stock) {
      cartItems[index].quantity++;
    } else if (index == -1) {
      cartItems.add(CartItem(product: product, quantity: 1));
    }
    return null;
  }

  String? updateQuantity(int index, int newQuantity) {
    final product = cartItems[index].product;
    if (newQuantity > product.stock) {
      return 'Stok ${product.name} tidak mencukupi.';
    }
    cartItems[index].quantity = newQuantity;
    return null;
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  void applyFilterAndSort() {
    final query = searchController.text.toLowerCase();
    filteredProducts = allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(query);
      final skuMatch = product.sku?.toLowerCase().contains(query) ?? false;
      return nameMatch || skuMatch;
    }).toList();

    // Logika sorting lainnya tetap...
  }

  void changeSortOption(ProductSortOption? newOption, VoidCallback onUpdate) {
    if (newOption != null && newOption != currentSortOption) {
      currentSortOption = newOption;
      applyFilterAndSort();
      onUpdate();
    }
  }

  // Eksekusi Transaksi & Pemotongan 2% dari Saldo Top-Up Penjual
  Future<Map<String, dynamic>> executeTransaction(String paymentMethod) async {
    if (cartItems.isEmpty) {
      return {'success': false, 'message': 'Keranjang masih kosong!'};
    }

    final double total = totalAmount;
    // Hitung potongan 2% dari total transaksi
    final double feeDeduction = total * 0.02;

    final newOrder = Order(
      id: '',
      orderDate: DateTime.now(),
      totalAmount: total,
      paymentMethod: paymentMethod,
      status: OrderStatus.completed,
      items: cartItems
          .map((cartItem) => OrderItem(
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                price: cartItem.product.sellingPrice,
                quantity: cartItem.quantity,
              ))
          .toList(),
      orderId: '',
      customerName: '',
      customerEmail: '',
      customerPhone: '',
    );

    final String? newOrderId = await _productService.createOrder(newOrder);
    bool success = false;

    if (newOrderId != null) {
      success = await _productService.updateStockForOrder(cartItems);
      
      if (success) {
        try {
          final dbRef = FirebaseDatabase.instance.ref();
          final transactionId = 'TRX-${DateTime.now().millisecondsSinceEpoch}';
          
          // 1. Catat riwayat transaksi penjualan
          await dbRef.child('transactions').child(transactionId).set({
            'id': transactionId,
            'totalAmount': total,
            'feeDeducted': feeDeduction, // Catat nominal potongan 2%
            'paymentMethod': paymentMethod,
            'changeAmount': paymentMethod.toLowerCase() == 'tunai' ? changeAmount : 0,
            'status': 'Berhasil',
            'timestamp': ServerValue.timestamp,
            'items': cartItems
                .map((item) => {
                      'productId': item.product.id,
                      'productName': item.product.name,
                      'quantity': item.quantity,
                      'price': item.product.sellingPrice,
                    })
                .toList(),
          });

          // 2. Potong saldo top-up penjual di database (Contoh path node: /seller/saldo)
          // Pastikan sesuaikan ID penjual jika aplikasinya multi-user
          final sellerSaldoRef = dbRef.child('seller/saldo');
          await sellerSaldoRef.runTransaction((mutableData) {
            double currentSaldo = 0.0;
            if (mutableData != null) {
              currentSaldo = double.tryParse(mutableData.toString()) ?? 0.0;
            }
            
            // Kurangi saldo dengan biaya potongan transaksi 2%
            double updatedSaldo = currentSaldo - feeDeduction;
            if (updatedSaldo < 0) updatedSaldo = 0; // Batasi minimal 0
            
            return Transaction.success(updatedSaldo);
          });

        } catch (e) {
          debugPrint("Gagal memproses potongan saldo penjual: $e");
        }

        cartItems.clear();
      }
    }

    return {
      'success': success, 
      'total': total,
      'transactionId': newOrderId,
      'items': List.from(cartItems),
    };
  }
}