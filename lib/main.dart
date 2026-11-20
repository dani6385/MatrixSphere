import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'navigations/app_router.dart';

Future<void> main() async {
  // Wajib dipanggil sebelum memakai plugin async seperti Firebase di main()
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Menginisialisasi Firebase sebelum `appRouter` mengakses `FirebaseAuth.instance`
    await Firebase.initializeApp();
  } catch (e) {
    // Mencatat error bila inisialisasi Firebase gagal (misal opsi platform belum diatur)
    debugPrint('Gagal menginisialisasi Firebase: $e');
  }

  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Matrix Sphere',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}