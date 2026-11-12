import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_router.dart';
import 'services/deep_linking.dart';
import 'services/firebase_options.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pastikan Firebase diinisialisasi sebelum menjalankan aplikasi
  try {
    // 1. Aktifkan kembali inisialisasi Firebase agar tidak bernilai null
    await AppInitializer.initializeFirebase(
        DefaultFirebaseOptions.currentPlatform);

    // 2. Ambil data status login dari penyimpanan lokal
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    // 3. Jalankan aplikasi utama sekali saja
    runApp(MatrixSphere(isLoggedIn: isLoggedIn));
  } catch (e) {
    debugPrint('Terjadi kesalahan saat inisialisasi: $e');
  }
}

class MatrixSphere extends StatefulWidget {
  final bool isLoggedIn;
  const MatrixSphere({super.key, required this.isLoggedIn});

  @override
  State<MatrixSphere> createState() => _MatrixSphereState();
}

// 2. State pendukung untuk MatrixSphere
class _MatrixSphereState extends State<MatrixSphere> {
  final DeepLinkHandler _deepLinkHandler = DeepLinkHandler();

  @override
  void initState() {
    super.initState();

    // Memulai mendengarkan deep link saat aplikasi pertama kali aktif
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinkHandler.initDeepLinks(context, appRouter);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Langsung gunakan MaterialApp.router.
    // GoRouter sekarang akan menangani semua logika navigasi dan otentikasi.
    return MaterialApp.router(
      title: 'Matrix Sphere',
      theme: ThemeData.light(), // Tema terang Anda
      darkTheme: ThemeData.dark(), // Tema gelap Anda
      themeMode: ThemeMode.system, // Atau sesuai preferensi Anda
      // Konfigurasi router yang sudah diperbarui
      routerConfig: appRouter,
    );
  }
}
