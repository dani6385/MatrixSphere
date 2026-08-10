import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/models/order_model.dart';
import 'package:shared_ui/shared_ui.dart'; // Menggunakan AppSpacing dari shared_ui

class OrderListView extends StatefulWidget {
  // Hapus parameter `orders` yang tidak digunakan.
  // Jadikan `shopId` sebagai parameter utama untuk widget ini.
  const OrderListView({super.key, required this.shopId});

  final String shopId;

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  // Query akan diinisialisasi di initState untuk menggunakan `widget.shopId`
  late final Query _ordersQuery;

  @override
  void initState() {
    super.initState();
    // Buat query yang memfilter pesanan berdasarkan 'shopId' dari widget.
    _ordersQuery = FirebaseDatabase.instance
        .ref('orders')
        .orderByChild('shopId')
        .equalTo(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
      ),
      body: FirebaseAnimatedList(
        query: _ordersQuery, // Gunakan query yang sudah difilter
        padding: const EdgeInsets.all(AppSpacing.md),
        itemBuilder: (context, snapshot, animation, index) {
          // Gunakan model `Order` untuk parsing yang lebih aman dan bersih
          if (!snapshot.exists || snapshot.value == null) {
            return const SizedBox.shrink();
          }

          // Konversi data snapshot ke Map dan buat objek Order
          final orderDataMap =
              Map<String, dynamic>.from(snapshot.value as Map);
          final order = Order.fromMap(orderDataMap, snapshot.key!);

          // Gunakan FadeTransition untuk animasi yang bagus saat item muncul
          return FadeTransition(
            opacity: animation,
            child: Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                title: Text(
                  order.customerName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('ID: ${order.orderId}\nStatus: ${order.status}'),
                trailing: Text(
                  'Rp ${order.totalAmount}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
                isThreeLine: true,
                onTap: () {
                  // TODO: Tambahkan aksi ketika item di-tap,
                  // misalnya navigasi ke halaman detail pesanan.
                },
              ),
            ),
          );
        },
      ),
    );
  }
}