import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/home/components/home_drawer.dart';
import 'package:seller_sphere/widgets/register_shop_banner.dart';
import 'package:shared_services/shared_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  // Menggunakan Future untuk menampung status kepemilikan toko
  late final Future<bool> _hasShopFuture;

  @override
  void initState() {
    super.initState();
    // Memeriksa status toko saat halaman diinisialisasi
    _hasShopFuture = _checkShopStatus();
  }

  Future<bool> _checkShopStatus() async {
    final shopId = await _authService.getCurrentShopId();
    // Jika shopId bukan 'toko_percobaan' dan tidak kosong, berarti toko ada
    return shopId != null && shopId.isNotEmpty && shopId != 'toko_percobaan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      drawer: const HomeDrawer(),
      body: Column(
        children: [
          // Menampilkan banner berdasarkan hasil pengecekan
          FutureBuilder<bool>(
            future: _hasShopFuture,
            builder: (context, snapshot) {
              final bool hasShop = snapshot.data ?? false;
              // Tampilkan banner hanya jika data sudah siap dan pengguna belum punya toko
              if (snapshot.connectionState == ConnectionState.done &&
                  !hasShop) {
                return const RegisterShopBanner();
              }
              // Sembunyikan banner jika punya toko, sedang loading, atau error
              return const SizedBox.shrink();
            },
          ),
          // Konten utama halaman home Anda bisa diletakkan di sini
          const Expanded(
            child: Center(
              child: Text('Selamat Datang di Seller Sphere!'),
            ),
          ),
        ],
      ),
    );
  }
}
