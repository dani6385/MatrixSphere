import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Pastikan file firebase_options.dart sudah ada dari hasil konfigurasi FlutterFire CLI
import 'services/firebase_options.dart';
// Sesuaikan path import ini dengan lokasi file appRouter milikmu
import 'navigations/app_router.dart'; 

void main() async {
  // 1. Memastikan binding Flutter siap sebelum menjalankan kode asynchronous (Firebase)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Menginisialisasi Firebase agar FirebaseAuth di appRouter tidak error saat aplikasi dibuka
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Menghubungkan aplikasi dengan variabel appRouter yang sudah kamu buat
      routerConfig: appRouter,
    );
  }
}