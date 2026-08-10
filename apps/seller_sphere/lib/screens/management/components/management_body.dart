import 'package:flutter/material.dart';

import 'cashier_body.dart';
import 'order_list_view.dart';

class ManagementBody extends StatefulWidget {
  const ManagementBody({super.key});

  @override
  State<ManagementBody> createState() => _ManagementBodyState();
}

class _ManagementBodyState extends State<ManagementBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            children: const [
              // Gunakan StreamBuilder untuk menampilkan daftar pesanan secara real-time
              // OrderListView sekarang akan mengambil datanya sendiri menggunakan FirebaseAnimatedList
              // Anda perlu mengganti 'toko_agan' dengan shopId yang sebenarnya dari pengguna yang login.
              // Ini bisa didapatkan dari Firebase Auth atau state management lainnya.
              OrderListView(shopId: 'toko_agan'),
              CashierBody(),
            ],
          ),
        ),
      ],
    );
  }
}
