// lib/screens/home_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/features/company/models/company_profile_model.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:matrix_sphere/screens/home/widgets/app_drawer.dart';
import 'package:matrix_sphere/screens/home/widgets/app_enddrawer.dart';
import 'package:matrix_sphere/screens/home/widgets/home_appbar.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final Stream<DatabaseEvent> _companyStream;
  Stream<DatabaseEvent>? _userStream;
  String? _boundUid;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _companyStream = FirebaseDatabase.instance
        .ref('company_profile')
        .onValue;
    _syncUserStream();
  }

  void _syncUserStream() {
    final User? user = FirebaseAuth.instance.currentUser;
    _currentUser = user;
    final String? uid = user?.uid;

    if (uid != _boundUid) {
      _boundUid = uid;
      _userStream = uid != null
          ? FirebaseDatabase.instance.ref('users/$uid').onValue
          : null;
    }
  }

  void _closeAnyOpenDrawer() {
    final ScaffoldState? state = _scaffoldKey.currentState;
    if (state == null) return;
    if (state.isDrawerOpen) {
      state.closeDrawer();
    }
    if (state.isEndDrawerOpen) {
      state.closeEndDrawer();
    }
  }

  void _openEndDrawerSafe() {
    final ScaffoldState? state = _scaffoldKey.currentState;
    if (state == null) return;
    if (state.isDrawerOpen) {
      state.closeDrawer();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _scaffoldKey.currentState?.openEndDrawer();
      });
      return;
    }
    if (!state.isEndDrawerOpen) {
      state.openEndDrawer();
    }
  }

  void _navigateAfterClosingDrawer(VoidCallback action) {
    _closeAnyOpenDrawer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      action();
    });
  }

  @override
  Widget build(BuildContext context) {
    _syncUserStream();

    final User? currentUser = _currentUser;
    final String email = currentUser?.email ?? 'user@email.com';

    return Scaffold(
      key: _scaffoldKey,
      appBar: HomeAppBar(
        onOpenEndDrawer: _openEndDrawerSafe,
      ),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: StreamBuilder<DatabaseEvent>(
        stream: _companyStream,
        builder: (context, snapshot) {
          Map<dynamic, dynamic>? rawCompanyData;
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            rawCompanyData =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          }

          // Gunakan CompanyProfileModel agar pemetaan data aman dan rapi
          final company = CompanyProfileModel.fromMap(rawCompanyData);

          return SharedProjectDrawer(
            menuBuilder: (context, currentRoute) {
              return getDrawerSideMenuItems(context, currentRoute);
            },
            header: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                // Tampilkan logo perusahaan dari ImgBB jika sudah diunggah
                backgroundImage: company.hasLogo
                    ? NetworkImage(company.logoUrl!)
                    : null,
                child: !company.hasLogo
                    ? const Icon(Icons.apartment, size: 40, color: Colors.blue)
                    : null,
              ),
              accountName: Text(company.name),
              accountEmail: Text(company.email),
              // Navigasi langsung ke halaman Profil Perusahaan saat header diketuk
              onDetailsPressed: () {
                _navigateAfterClosingDrawer(() {
                  AppNavigation.openCompanyProfile(context);
                });
              },
            ),
          );
        },
      ),
      endDrawer: _userStream == null
          ? _buildEndDrawer(
              context: context,
              displayName: currentUser?.displayName ?? 'Pengguna MatrixSphere',
              email: email,
              photoUrl: currentUser?.photoURL,
            )
          : StreamBuilder<DatabaseEvent>(
              stream: _userStream,
              builder: (context, snapshot) {
                Map<dynamic, dynamic> userData = {};
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  userData =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                }

          // Ambil data dari RTDB dengan fallback ke FirebaseAuth
          final String displayName =
                    userData['name']?.toString() ??
                    currentUser?.displayName ??
                    'Pengguna MatrixSphere';
                final String? photoUrl =
                    userData['photoUrl']?.toString() ?? currentUser?.photoURL;

                return _buildEndDrawer(
                  context: context,
                  displayName: displayName,
                  email: email,
                  photoUrl: photoUrl,
                );
              },
            ),
      body: //const HomeBody(),
      ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Kartu Sambutan Utama
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Selamat Datang!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ini adalah tampilan standar halaman utama (Home) Matrix Sphere. Silakan pilih menu di samping atau navigasi bawah untuk mulai menggunakan fitur lainnya.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Contoh Daftar Menu Pintasan Standar
          const Text(
            'Menu Cepat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.approval, color: Colors.blue),
            title: const Text('Persetujuan (Approval)'),
            subtitle: const Text('Kelola daftar persetujuan toko'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Tambahkan navigasi ke halaman approval jika diperlukan
            },
          ),
        ],
      ),
    );
  }
  Widget _buildEndDrawer({
    required BuildContext context,
    required String displayName,
    required String email,
    required String? photoUrl,
  }) {
    return SharedProjectDrawer(
      header: UserAccountsDrawerHeader(
        decoration: const BoxDecoration(color: Colors.blue),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
              ? NetworkImage(photoUrl)
              : null,
          child: (photoUrl == null || photoUrl.isEmpty)
              ? const Icon(Icons.person, size: 40, color: Colors.blue)
              : null,
        ),
        accountName: Text(displayName),
        accountEmail: Text(email),
        onDetailsPressed: () {
          _navigateAfterClosingDrawer(() {
            AppNavigation.openUserProfile(context);
          });
        },
      ),
      menuBuilder: (context, currentRoute) {
        return getEndDrawerSideMenuItems(context, currentRoute);
      },
    );
  }
}