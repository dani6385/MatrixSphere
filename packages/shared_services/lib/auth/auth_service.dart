import 'package:shared_core/shared_core.dart';
import 'package:flutter/material.dart';
import 'auth_storage.dart'; // Impor file penyimpanan di atas

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthStorage _storage = AuthStorage(); // Panggil instance AuthStorage

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Login ke Firebase
  Future<UserCredential> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);

      if (credential.user != null) {
        String? token = await credential.user!.getIdToken();
        if (token != null) {
          await _storage.saveToken(token); // Simpan token via AuthStorage
        }
      }

      notifyListeners();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login gagal.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat login.');
    }
  }

  // Daftar Akun Baru
  Future<UserCredential> createUserAccount(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      if (userCredential.user != null) {
        String? token = await userCredential.user!.getIdToken();
        if (token != null) {
          await _storage.saveToken(token); // Simpan token via AuthStorage
        }
      }

      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registrasi gagal.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat registrasi.');
    }
  }

  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception('Gagal mengirim email: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan.');
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.clearToken(); // Hapus token via AuthStorage
    await _auth.signOut();
    notifyListeners();
  }

  // Delegasi fungsi remember me agar luar kelas tetap bisa memanggil lewat AuthService
  Future<Map<String, dynamic>> loadSavedCredentials() =>
      _storage.loadSavedCredentials();
  Future<void> saveOrClearCredentials(
          bool rememberMe, String email, String password) =>
      _storage.saveOrClearCredentials(rememberMe, email, password);

  String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Password salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar.';
      case 'weak-password':
        return 'Password terlalu lemah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Operasi login/registrasi tidak diizinkan.';
      case 'requires-recent-login':
        return 'Silakan login kembali dan coba lagi.';
      default:
        return e.message ?? 'Terjadi kesalahan autentikasi.';
    }
  }
}
