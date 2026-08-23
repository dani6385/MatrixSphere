import 'package:flutter/material.dart';
import 'package:shared_screens/shared_screens.dart';
//import 'package:matrix_sphere/navigations/app_router.dart';
// BaseApp tidak digunakan untuk sementara
//import 'screens/attendance/attendance_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*await AppInitializer.initializeFirebase(
      DefaultFirebaseOptions.currentPlatform);*/
  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  @override
  Widget build(BuildContext context) {
    // Anda bisa membungkus dengan BlocProvider di sini
    return /*ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: BaseApp(
        title: 'Matrix Sphere',
        //routerConfig: appRouter,
        themeMode: ThemeMode.system,
      ),*/
        MaterialApp(
      title: 'Aplikasi Login',
      debugShowCheckedModeBanner:
          false, // Menghilangkan banner debug di kanan atas
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // Menggunakan desain Material 3 terbaru
      ),
      // Memanggil LoginScreen sebagai halaman pertama yang muncul
      home: const LoginScreen(appType: AppType.matrix),
    );
  }
}
