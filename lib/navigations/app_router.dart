import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 1. Impor halaman-halaman yang Anda miliki di dalam aplikasi
// (Sesuaikan path impor di bawah ini dengan struktur folder Anda)
// import '../features/auth/presentation/login_screen.dart';
// import '../features/home/presentation/home_screen.dart';

// 2. Definisi GoRouter utama
final GoRouter appRouter = GoRouter(
  // Menentukan rute awal saat aplikasi pertama kali dibuka
  initialLocation: '/',
  
  // Penanganan jika rute tidak ditemukan (Halaman 404)
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.uri.path}'),
    ),
  ),

  // Daftar rute (routes) yang tersedia di aplikasi
  routes: <RouteBase>[
    // Rute Halaman Utama / Home
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        // Ganti dengan widget HomeScreen Anda
        return const PlaceholderScreen(title: 'Halaman Utama (Home)');
      },
    ),

    // Rute Halaman Login
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (BuildContext context, GoRouterState state) {
        // Ganti dengan widget LoginScreen Anda
        return const PlaceholderScreen(title: 'Halaman Login');
      },
    ),
    
    // Contoh rute dengan parameter (misal: detail item)
    // GoRoute(
    //   path: '/detail/:id',
    //   name: 'detail',
    //   builder: (BuildContext context, GoRouterState state) {
    //     final id = state.pathParameters['id'] ?? '';
    //     return DetailScreen(id: id);
    //   },
    // ),
  ],
);

// Widget sementara sebagai placeholder jika halaman aslinya belum diimpor
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}