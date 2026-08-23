class AuthService {
  // Fungsi untuk menangani login (bisa dikoneksikan ke Firebase atau API Anda nanti)
  Future<bool> login(String email, String password) async {
    // Simulasi delay koneksi ke server
    await Future.delayed(const Duration(seconds: 2));

    // Logika verifikasi sederhana (silakan ganti dengan pemicu API asli Anda)
    if (email == "admin@mail.com" && password == "123456") {
      return true; // Login sukses
    } else {
      throw Exception("Email atau password salah."); // Login gagal
    }
  }
}