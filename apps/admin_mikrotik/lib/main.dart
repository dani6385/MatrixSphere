import 'package:flutter/material.dart';
import 'package:shared_screens/shared_screens.dart';
//import 'services/deep_linking.dart';
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
    runApp(AdminMikrotik(isLoggedIn: isLoggedIn));
  } catch (e) {
    debugPrint('Terjadi kesalahan saat inisialisasi: $e');
  }
}

class AdminMikrotik extends StatelessWidget {
  const AdminMikrotik({super.key, required bool isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // Anda bisa membungkus dengan BlocProvider di sini
    return /*ChangeNotifierProvider(
      create: (_) => AppViewModel(),
      child: BaseApp(
        title: 'Matrix Sphere',
        //routerConfig: appRouter,
        themeMode: ThemeMode.system,
      ),*/ MaterialApp(
      title: 'Aplikasi Login',
      debugShowCheckedModeBanner:
          false, // Menghilangkan banner debug di kanan atas
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // Menggunakan desain Material 3 terbaru
      ),
      // Memanggil LoginScreen sebagai halaman pertama yang muncul
      home: const LoginScreen(),
    );
  }
}
