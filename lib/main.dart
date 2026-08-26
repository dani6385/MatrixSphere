import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const AppType currentActiveApp = AppType.matrixSphere;
    return MaterialApp(
      title: 'Matrix Sphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // KITA GUNAKAN SEBAGAI TITIK AWAL RUTE:
      // Saat ini kita arahkan ke PageType.login sebagai gerbang awal aplikasi
      home: const MainScreen(
        currentApp: currentActiveApp,
        currentPage: PageType.login, // Ubah ke PageType halaman yang ingin diuji
      ),
    );
  }
}
