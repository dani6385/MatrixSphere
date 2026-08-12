import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahan untuk memori lokal

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream untuk memantau perubahan status otentikasi pengguna
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mendapatkan pengguna yang sedang login
  User? get currentUser => _auth.currentUser;

  // Cek status login
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Fungsi Login yang Diperbarui dengan Penyimpanan Token
  Future<UserCredential> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      
      // Ambil dan simpan token ke SharedPreferences
      if (credential.user != null) {
        String? token = await credential.user!.getIdToken();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', token ?? '');
      }

      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Login gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  // Fungsi Register Akun yang Diperbarui dengan Penyimpanan Token[cite: 1]
  Future<UserCredential> createUserAccount(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      // Ambil dan simpan token untuk akun baru
      if (userCredential.user != null) {
        String? token = await userCredential.user!.getIdToken();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_token', token ?? '');
      }

      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('Registrasi gagal: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi.');
    }
  }

  // Fungsi Kirim Email Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Gagal mengirim email: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan.');
    }
  }

  // Fungsi Logout yang Diperbarui (Menghapus Token)[cite: 1]
  Future<void> logout() async {
    // Hapus token dari memori lokal saat logout
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');

    await _auth.signOut();
    notifyListeners();
  }
}