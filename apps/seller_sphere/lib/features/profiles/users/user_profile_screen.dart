import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/auth/auth_service.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    final user = _authService.currentUser;
    if (user == null) {
      // Seharusnya tidak terjadi jika redirect berfungsi, tapi sebagai pengaman
      return null;
    }
    // Mengambil data seller yang juga berisi nama toko
    return _authService.getSellerData(user.uid);
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      // Menggunakan `go` untuk mereset stack navigasi ke halaman login
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(snapshot.error?.toString() ?? 'Gagal memuat data pengguna.'),
            );
          }

          final userData = snapshot.data!;
          final shopName = userData['shopName'] as String? ?? 'Nama Toko Tidak Ditemukan';
          final email = userData['email'] as String? ?? 'Email Tidak Ditemukan';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.store),
                          title: const Text('Nama Toko'),
                          subtitle: Text(shopName),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text('Email'),
                          subtitle: Text(email),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}