// Disimpan di direktori: packages/shared_logics/lib/src/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:go_router/go_router.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Menangani alur login, validasi database matrix_members, dan navigasi role
  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      // 1. Jalankan proses login Firebase murni dari AuthService
      final credential = await _authService.login(email, password);
      final user = credential.user;

      if (user != null) {
        String? uid = user.uid;

        // 2. Periksa izin akses di database "matrix_members"
        DatabaseEvent event = await _database.ref("matrix_members/$uid").once();

        if (event.snapshot.exists) {
          // Konversi aman untuk menghindari TypeError saat mode minified/release
          final rawData = event.snapshot.value;
          
          if (rawData is Map) {
            // Ubah secara aman ke Map<String, dynamic> agar terhindar dari mismatch tipe minifikasi
            final Map<String, dynamic> memberData = {};
            rawData.forEach((key, value) {
              if (key != null) {
                memberData[key.toString()] = value;
              }
            });

            bool isAllowed = memberData['isAllowed'] == true;
            String role = memberData['role']?.toString() ?? 'member';

            if (!isAllowed) {
              await _authService.logout();
              throw FirebaseAuthException(
                code: 'access-denied',
                message: 'Akses Anda telah ditangguhkan oleh Admin.',
              );
            }

            // 3. Navigasi berdasarkan role jika widget masih aktif (mounted)
            if (context.mounted) {
              if (role == 'admin') {
                context.go('/admin-home');
              } else {
                context.go('/');
              }
            }
          } else {
            await _authService.logout();
            throw Exception('Format data member di database tidak valid.');
          }
        } else {
          // Jika UID tidak ditemukan di matrix_members
          await _authService.logout();
          throw FirebaseAuthException(
            code: 'access-denied',
            message: 'Akun Anda belum terdaftar di sistem Matrix.',
          );
        }
      }
    } catch (e) {
      // Pastikan exception diteruskan (rethrow) agar LoginForm / pemanggil 
      // tahu bahwa login gagal dan bisa menghentikan status _isLoading = false.
      if (e is FirebaseAuthException) {
        rethrow;
      } else if (e is Exception) {
        rethrow;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  // Fungsi untuk menerjemahkan error Firebase ke bahasa Indonesia
  String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'access-denied':
        return e.message ?? 'Akun Anda tidak memiliki izin akses ke aplikasi Matrix Sphere.';
      case 'user-not-found':
        return 'Akun dengan email ini tidak ditemukan.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah. Silakan periksa kembali.';
      case 'invalid-email':
        return 'Format alamat email tidak valid.';
      case 'user-disabled':
        return 'Akun pengguna ini telah dinonaktifkan oleh administrator.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan gagal. Silakan coba lagi beberapa saat.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Pastikan perangkat terhubung ke internet.';
      case 'channel-error':
        return 'Mohon lengkapi email dan kata sandi Anda.';
      default:
        return e.message ?? 'Autentikasi gagal. Silakan coba lagi.';
    }
  }
}