
import 'package:flutter/material.dart';
//import 'package:matrix_sphere/navigations/app_router.dart';
import 'package:shared_services/shared_services.dart';
//import 'package:shared_ui/shared_ui.dart';
import 'services/firebase_options.dart';
import 'screens/homes/home_screen.dart';

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
    // Anda bisa membungkus dengan BlocProvider di sini
    return const MaterialApp(
      title: 'Matrix Sphere',
      home: HomeScreen(),
    /*BaseApp(
      title: 'Matrix Sphere',
      routerConfig: appRouter,
      themeMode: ThemeMode.system,*/
    );
  }
}
