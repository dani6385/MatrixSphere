// lib/screens/management/components/cashier_body.dart

import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/management/logic/cashier_logic.dart';
import 'package:shared_services/shared_services.dart';


class CashierBody extends StatelessWidget {
  final CashierLogic cashierLogic;
  final VoidCallback onStateChanged;

  const CashierBody({
    super.key,
    required this.cashierLogic,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // BAGIAN KIRI: Daftar Produk yang bisa dipilih
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // 1. Kotak Pencarian Produk
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: cashierLogic.searchController,
                  decoration: const InputDecoration(
                    labelText: 'Cari produk atau SKU...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              
              // 2. Daftar Grid/List Produk Berdasarkan Hasil Filter
              Expanded(
                child: ListView.builder(
                  itemCount: cashierLogic.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final Product product = cashierLogic.filteredProducts[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('Stok: ${product.stock} | Rp ${product.sellingPrice}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          // Menambahkan produk ke keranjang melalui logika kasir
                          final String? errorMsg = cashierLogic.addProductToCart(product);
                          if (errorMsg != null) {
                            // Tampilkan pesan error jika stok habis
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorMsg)),
                            );
                          } else {
                            // Perbarui tampilan UI
                            onStateChanged();
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const VerticalDivider(width: 1),

        // BAGIAN KANAN: Daftar Keranjang Belanja & Total Pembayaran
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Keranjang Belanja',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              // Daftar Item di dalam Keranjang
              Expanded(
                child: ListView.builder(
                  itemCount: cashierLogic.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cashierLogic.cartItems[index];
                    return ListTile(
                      title: Text(cartItem.product.name),
                      subtitle: Text('Rp ${cartItem.product.sellingPrice} x ${cartItem.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tombol Kurangi Kuantitas / Hapus
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (cartItem.quantity > 1) {
                                cashierLogic.updateQuantity(index, cartItem.quantity - 1);
                              } else {
                                cashierLogic.removeItem(index);
                              }
                              onStateChanged();
                            },
                          ),
                          Text('${cartItem.quantity}'),
                          // Tombol Tambah Kuantitas
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final String? errorMsg = cashierLogic.updateQuantity(index, cartItem.quantity + 1);
                              if (errorMsg != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMsg)),
                                );
                              }
                              onStateChanged();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bagian Total Harga & Tombol Bayar
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: Rp ${cashierLogic.totalAmount}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: cashierLogic.cartItems.isEmpty
                          ? null
                          : () async {
                              // Contoh Eksekusi Transaksi Tunai
                              final result = await cashierLogic.executeTransaction('Tunai');
                              if (result['success'] == true) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Transaksi Berhasil!')),
                                );
                                onStateChanged();
                              }
                            },
                      child: const Text('Proses Pembayaran'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}