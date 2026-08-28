// Disimpan di direktori: packages/shared_logics/lib/src/auth_controller.dart (atau sesuaikan jalurnya)
import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Menangani alur login, validasi database matrix_members, dan navigasi role
  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    try {
      // 1. Jalankan proses login Firebase murni dari AuthService
      final credential = await _authService.login(email, password);
      final user = credential.user;

      if (user != null) {
        String? uid = user.uid;

        // 2. Periksa izin akses di database "matrix_members"
        DatabaseEvent event = await _database.ref("matrix_members/$uid").once();

        if (event.snapshot.exists) {
          // Konversi aman untuk menghindari TypeError
          final rawData = event.snapshot.value;
          if (rawData is Map) {
            Map<dynamic, dynamic> memberData = rawData;

            bool isAllowed = memberData['isAllowed'] ?? false;
            String role = memberData['role'] ?? 'member';

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
                AppNavigation.goToHome(context);
              } else {
                AppNavigation.pushToUserProfile(context);
              }
            }
          } else {
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
    } on FirebaseAuthException catch (e) {
      print("DEBUG FIREBASE AUTH ERROR: ${e.code} - ${e.message}");
      throw Exception(handleAuthError(e));
    } catch (e, stackTrace) {
      print("DEBUG ERROR MENTAH: $e");
      print("DEBUG STACKTRACE: $stackTrace");
      throw Exception('Terjadi kesalahan: $e'); 
    }
    /*catch (e) {
      // 4. Tampilkan pesan kesalahan di UI menggunakan SnackBar
      if (context.mounted) {
        String errorMessage = 'Terjadi kesalahan saat masuk.';

        if (e is FirebaseAuthException) {
          errorMessage = handleAuthError(e);
        } else {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        }

        UiHelper.showSnackBar(context, errorMessage);
      }
    }*/
  }

  // Fungsi untuk menerjemahkan error Firebase ke bahasa Indonesia
  String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'access-denied':
        return e.message ??
            'Akun Anda tidak memiliki izin akses ke aplikasi Matrix Sphere.';
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
