import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:matrix_sphere/navigations/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SellerSphere());
}

class SellerSphere extends StatelessWidget {
  const SellerSphere({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seller Sphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SellerAuthCheckScreen(),
    );
  }
}

/// Widget perantara untuk mengecek status login penjual
class SellerAuthCheckScreen extends StatelessWidget {
  const SellerAuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Jika status masih memuat
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Jika belum login, arahkan ke halaman Login Seller
        if (!snapshot.hasData) {
          return const SellerLoginScreen();
        }

        // Jika sudah login, periksa status persetujuan (approval) di RTDB
        final User user = snapshot.data!;
        final DatabaseReference sellerRef =
            FirebaseDatabase.instance.ref('sellers/${user.uid}');

        return StreamBuilder<DatabaseEvent>(
          stream: sellerRef.onValue,
          builder: (context, sellerSnapshot) {
            if (sellerSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Ambil data status seller dari database
            final Object? rawData = sellerSnapshot.data?.snapshot.value;
            final Map<dynamic, dynamic> sellerData =
                (rawData is Map) ? rawData : {};
            
            // Cek apakah admin matrix sudah menyetujui (default: false)
            final bool isApproved = sellerData['isApproved'] == true;

            if (!isApproved) {
              return const SellerWaitingApprovalScreen();
            }

            // Jika sudah disetujui, masuk ke Dashboard Seller
            return const SellerDashboardScreen();
          },
        );
      },
    );
  }
}

// ==========================================
// KUMPULAN SCREEN SEMENTARA UNTUK ALUR SELLER
// ==========================================

class SellerLoginScreen extends StatelessWidget {
  const SellerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Seller Sphere')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Selamat Datang di Seller Sphere',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Silakan masuk untuk mendaftarkan toko Anda ke pasar Matrix Sphere.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implementasi logika Login Firebase Auth di sini
                },
                child: const Text('Masuk / Daftar Akun Seller'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerWaitingApprovalScreen extends StatelessWidget {
  const SellerWaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menunggu Persetujuan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_top, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'Akun Seller Sedang Ditinjau',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Permohonan Anda untuk bergabung dan berjualan di pasar Matrix Sphere sedang menunggu persetujuan dari Admin Utama.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Keluar (Log Out)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Seller Sphere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Selamat! Akun Anda telah disetujui.\nAnda sekarang dapat mengelola produk dan berjualan di Matrix Sphere.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}