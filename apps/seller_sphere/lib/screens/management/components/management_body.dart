import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'cashier_body.dart';
// Impor widget untuk menampilkan daftar pesanan
import 'order_list_view.dart';

class ManagementBody extends StatefulWidget {
  const ManagementBody({super.key});

  @override
  State<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends State<ManagementBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // Buat instance dari service RTDB dan stream pesanan
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late final Stream<List<Order>> _ordersStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inisialisasi stream di sini. Ganti 'toko_agan' dengan ID toko dinamis jika perlu.
    _ordersStream = _rtdbService.getOrdersStreamForShop('toko_agan');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Orderan'),
            Tab(icon: Icon(Icons.point_of_sale_outlined), text: 'Kasir'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Gunakan StreamBuilder untuk menampilkan daftar pesanan secara real-time
              StreamBuilder<List<Order>>(
                stream: _ordersStream,
                builder: (context, snapshot) {
                  // 1. Saat sedang memuat data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Jika terjadi error
                  if (snapshot.hasError) {
                    return Center(child: Text('Terjadi error: ${snapshot.error}'));
                  }

                  // 3. Jika data berhasil didapat (meskipun kosong)
                  if (snapshot.hasData) {
                    final orders = snapshot.data!;
                    return OrderListView(orders: orders, shopId: '',);
                  }

                  // 4. State lainnya (jika stream belum menghasilkan data)
                  return const Center(child: Text('Memuat data pesanan...'));
                },
              ),
              const CashierBody(),
            ],
          ),
        ),
      ],
    );
  }
}
