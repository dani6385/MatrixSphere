// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'logics/home_logic.dart';
import 'components/home_drawer.dart';
import 'package:seller_sphere/widgets/register_shop_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Inisialisasi HomeLogic
  final HomeLogic _homeLogic = HomeLogic();
  
  // Menggunakan Future untuk menampung status kepemilikan toko dari logic
  late final Future<bool> _hasShopFuture;
  
  // State untuk mengontrol visibilitas banner
  bool _isBannerVisible = true;

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi pengecekan status dari HomeLogic
    _hasShopFuture = _homeLogic.checkShopStatus();
  }

  // Fungsi untuk menutup banner
  void _dismissBanner() {
    setState(() {
      _isBannerVisible = false;
    });
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
          // Menampilkan banner berdasarkan hasil pengecekan dan status visibilitas
          FutureBuilder<bool>(
            future: _hasShopFuture,
            builder: (context, snapshot) {
              final bool hasShop = snapshot.data ?? false;
              // Tampilkan banner hanya jika:
              // 1. Data sudah siap (connectionState.done)
              // 2. Pengguna belum punya toko (!hasShop)
              // 3. Banner belum ditutup oleh pengguna (_isBannerVisible)
              if (snapshot.connectionState == ConnectionState.done && 
                  !hasShop && 
                  _isBannerVisible) {
                return RegisterShopBanner(onDismiss: _dismissBanner);
              }
              // Sembunyikan banner jika punya toko, sedang loading, error, atau sudah ditutup
              return const SizedBox.shrink();
            },
          ),
          // Konten utama halaman home
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