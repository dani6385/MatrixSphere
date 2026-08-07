
// lib/screens/management/cashier_logic.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import '../widgets/cashier_sort_dropdown.dart';
import 'cashier_cart_logic.dart';

class CashierLogic {
  final ProductService _productService = ProductService();
  
  // Menggabungkan logika keranjang
  final CashierCartLogic cartLogic = CashierCartLogic();

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  ProductSortOption currentSortOption = ProductSortOption.none;
  final TextEditingController searchController = TextEditingController();

  // Getter delegasi untuk mempermudah akses dari UI
  List get cartItems => cartLogic.cartItems;
  double get totalAmount => cartLogic.totalAmount;
  double get cashPaid => cartLogic.cashPaid;
  double get changeAmount => cartLogic.changeAmount;
  bool get isCashValid => cartLogic.isCashValid;

  void updateCashPaid(String value) => cartLogic.updateCashPaid(value);
  String? addProductToCart(Product product) => cartLogic.addProductToCart(product);
  String? updateQuantity(int index, int newQuantity) => cartLogic.updateQuantity(index, newQuantity);
  void removeItem(int index) => cartLogic.removeItem(index);

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

  void applyFilterAndSort() {
    final query = searchController.text.toLowerCase();
    filteredProducts = allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(query);
      final skuMatch = product.sku?.toLowerCase().contains(query) ?? false;
      return nameMatch || skuMatch;
    }).toList();

    switch (currentSortOption) {
      case ProductSortOption.none:
        break;
      case ProductSortOption.mostSold:
        filteredProducts.sort((a, b) => b.soldCount.compareTo(a.soldCount));
        break;
      case ProductSortOption.priceLowToHigh:
        filteredProducts.sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
        break;
      case ProductSortOption.priceHighToLow:
        filteredProducts.sort((a, b) => b.sellingPrice.compareTo(a.sellingPrice));
        break;
      case ProductSortOption.nameAsc:
        filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.nameDesc:
        filteredProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
  }

  void changeSortOption(ProductSortOption? newOption, VoidCallback onUpdate) {
    if (newOption != null && newOption != currentSortOption) {
      currentSortOption = newOption;
      applyFilterAndSort();
      onUpdate();
    }
  }

  Future<Map<String, dynamic>> executeTransaction(String paymentMethod) async {
    if (cartLogic.cartItems.isEmpty) {
      return {'success': false, 'message': 'Keranjang masih kosong!'};
    }

    final newOrder = Order(
      id: '',
      orderDate: DateTime.now(),
      totalAmount: cartLogic.totalAmount,
      paymentMethod: paymentMethod,
      status: OrderStatus.completed,
      items: cartLogic.cartItems
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
      success = await _productService.updateStockForOrder(cartLogic.cartItems.cast<CartItem>());
    }

    if (success) {
      cartLogic.clearCart();
    }

    return {'success': success, 'total': cartLogic.totalAmount};
  }
}
