import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_router.dart';
import 'package:shared_services/shared_services.dart';
// import 'package:shared_ui/shared_ui.dart'; // BaseApp tidak digunakan untuk sementara
import 'services/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initializeFirebase(
      DefaultFirebaseOptions.currentPlatform);
  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan MaterialApp.router secara langsung untuk melewati BaseApp
    return MaterialApp.router(
      title: 'Matrix Sphere',
      routerConfig: appRouter,
      themeMode: ThemeMode.system,
      // Mungkin perlu menambahkan theme data di sini jika BaseApp melakukannya
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

