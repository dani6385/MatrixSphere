import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler {
  late AppLinks _appLinks;
  
  // Fungsi untuk menginisialisasi listener App Links
  void initDeepLinks(BuildContext context, GoRouter router) {
    _appLinks = AppLinks();

    // 1. Menangani link saat aplikasi dibuka dari keadaan tertutup (terminated)
    _appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null) {
        _handleUriNavigation(uri, router);
      }
    });

    // 2. Menangani link saat aplikasi berjalan di background atau foreground
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleUriNavigation(uri, router);
      }
    }, onError: (err) {
      debugPrint('Gagal mendengarkan deep link: $err');
    });
  }

  // Fungsi untuk mengarahkan rute berdasarkan path dari URL
  void _handleUriNavigation(Uri uri, GoRouter router) {
    // Contoh: Jika URL nya https://namadomainanda.com/profile
    String path = uri.path; 
    
    debugPrint('Deep link tertangkap: $uri');
    
    // Anda bisa meneruskan path tersebut ke GoRouter
    if (path.isNotEmpty) {
      router.go(path);
    }
  }
}