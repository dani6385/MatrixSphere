import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_services/shared_services.dart';
import 'services/firebase_options.dart';
import 'navigations/app_router.dart'; 

void main() async {
  // 1. Memastikan binding Flutter siap sebelum menjalankan kode asynchronous (Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Menginisialisasi Firebase agar FirebaseAuth di appRouter tidak error saat aplikasi dibuka
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await crashlyticsService.initialize();
  await crashlyticsService.setCustomKey('app_name', 'matrix_sphere');

  // 3. Menjalankan aplikasi utama
  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp.router agar navigasi dikendalikan sepenuhnya oleh go_router
    return MaterialApp.router(
      title: 'MatrixSphere',
      debugShowCheckedModeBanner: false, // Menghilangkan pita "DEBUG" di pojok kanan atas
      theme: ThemeData.light(), // Tema terang Anda
      darkTheme: ThemeData.dark(), // Tema gelap Anda
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}