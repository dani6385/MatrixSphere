import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'shop_status.enum.dart';

/// [ShopService]
///
/// Kelas ini adalah satu-satunya sumber kebenaran (single source of truth) untuk semua
/// operasi yang berkaitan dengan toko pengguna. Ia menangani pendaftaran,
/// pemeriksaan status, dan pengambilan data toko.
///
/// Mewarisi [ChangeNotifier] agar bisa memberi notifikasi pada UI tentang perubahan,
/// dan digunakan oleh `Provider` di seluruh aplikasi.
class ShopService extends ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Memeriksa status toko pengguna saat ini.
  ///
  /// Metode ini adalah kunci untuk logika `redirect` pada `AuthGuard`.
  /// Urutan pemeriksaan:
  /// 1. Cek node `seller_sphere` -> jika ada, toko sudah `approved`.
  /// 2. Cek node `shops_pending_approval` -> jika ada, statusnya `pending`.
  /// 3. Jika tidak ada di mana pun, statusnya `none`.
  Future<ShopStatus> getUserShopStatus(User? currentUser) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return ShopStatus.none;

    final uid = currentUser.uid;
    try {
      // 1. Cek apakah toko sudah disetujui (berada di seller_sphere)
      final sellerSnapshot = await _dbRef.child('seller_sphere/$uid').get();
      if (sellerSnapshot.exists) {
        return ShopStatus.approved;
      }

      // 2. Cek apakah toko sedang dalam proses approval
      final pendingSnapshot =
          await _dbRef.child('shops_pending_approval/$uid').get();
      if (pendingSnapshot.exists) {
        return ShopStatus.pending;
      }

      // 3. Jika tidak ditemukan di mana pun
      return ShopStatus.none;
    } catch (e) {
      debugPrint('Error saat memeriksa status toko: $e');
      // Jika terjadi error, kembalikan 'none' untuk keamanan.
      return ShopStatus.none;
    }
  }

  /// Mendaftarkan toko baru dan menempatkannya dalam status 'pending approval'.
  ///
  /// Data akan disimpan di node `shops_pending_approval` untuk direview oleh admin.
  Future<void> registerShop({
    required String shopName,
    required String pickupAddress,
    Position? coordinates,
  }) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Pengguna tidak login. Tidak dapat mendaftarkan toko.");
    }

    try {
      final pendingShopRef =
          _dbRef.child('shops_pending_approval').child(currentUser.uid);

      final Map<String, dynamic> shopData = {
        'ownerUid': currentUser.uid,
        'shopName': shopName,
        'email': currentUser.email ?? '',
        'pickupAddress': pickupAddress,
        'pickupCoordinates': coordinates != null
            ? {
                'latitude': coordinates.latitude,
                'longitude': coordinates.longitude
              }
            : null,
        'createdAt': ServerValue.timestamp,
        'status': ShopStatus.pending.name, // Gunakan enum untuk konsistensi
      };

      await pendingShopRef.set(shopData);
      notifyListeners(); // Beri notifikasi jika ada UI yang perlu di-update
    } on FirebaseException catch (e) {
      throw Exception('Gagal mendaftarkan toko di Firebase: ${e.message}');
    } catch (e) {
      throw Exception(
          'Terjadi kesalahan tidak terduga saat mendaftarkan toko: $e');
    }
  }

  /// Mengambil data lengkap dari toko yang sudah disetujui.
  ///
  /// Mengembalikan `Map` data toko jika ditemukan di node `seller_sphere`,
  /// jika tidak, mengembalikan `null`.
  Future<Map<String, dynamic>?> getApprovedShopData() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    try {
      final snapshot =
          await _dbRef.child('seller_sphere/${currentUser.uid}').get();
      if (snapshot.exists && snapshot.value != null) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data toko: $e');
    }
  }

  Future<void> createInitialShopEntry(
      {required User user, required String shopName}) async {}
}
