import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_router.dart';
import 'services/firebase_options.dart';
import 'package:shared_services/shared_services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pastikan Firebase diinisialisasi sebelum menjalankan aplikasi
  await AppInitializer.initializeFirebase(
      DefaultFirebaseOptions.currentPlatform);

  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

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
