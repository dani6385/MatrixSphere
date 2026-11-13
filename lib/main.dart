import 'package:flutter/material.dart';
import 'navigations/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pastikan Firebase terinisialisasi agar tidak terjadi error tertahan
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  runApp(const MatrixSphere(isLoggedIn: false));
}

class MatrixSphere extends StatefulWidget {
  final bool isLoggedIn;
  const MatrixSphere({super.key, required this.isLoggedIn});

  @override
  State<MatrixSphere> createState() => _MatrixSphereState();
}

class _MatrixSphereState extends State<MatrixSphere> {
  /*final DeepLinkHandler _deepLinkHandler = DeepLinkHandler();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinkHandler.initDeepLinks(context, appRouter);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Matrix Sphere',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}