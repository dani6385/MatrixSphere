import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import '../states/shop_registration_state.dart';

class ShopRegistrationLogic {
  final AuthService _authService = AuthService();
  final ShopService shopService = ShopService();
  // 1. Tambahkan LocationService agar bisa digunakan.
  final LocationService _locationService = LocationService();

  /// Mendapatkan lokasi GPS pengguna saat ini
  Future<void> getCurrentLocation({
    required ShopRegistrationState state,
    required VoidCallback onUpdate,
  }) async {
    try {
      // 2. Gunakan LocationService yang sudah ada.
      // Metode ini sudah menangani izin dan error secara internal.
      final position = await _locationService.getCurrentLocation();
      state.mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 17.0, // Zoom lebih dekat untuk akurasi pin point
          ),
        ),
      );
    } catch (e) {
      // Gagal mendapatkan lokasi, bisa tampilkan pesan error jika perlu.
      // Contoh: showErrorDialog(context: context, message: e.toString());
      if (kDebugMode) {
        print('Gagal mendapatkan lokasi: $e');
      }
    }
  }
Future<void> getShopStatus({
    required ShopRegistrationState state, 
    required VoidCallback onUpdate
  }) async {
    try {
      // 1. Tampilkan loading sementara
      state.isLoading = true;
      onUpdate();
      state.shopStatus = 'none'; 

    } catch (e) {
      if (kDebugMode) {
        print("Gagal mengambil status toko: $e");
      }
      state.shopStatus = 'none'; // Default jika error
    } finally {
      // 4. Matikan loading dan update UI
      state.isLoading = false;
      onUpdate();
    }
  }
  /// Menangani proses pendaftaran toko
  Future<void> handleRegisterShop({
    required BuildContext context,
    required ShopRegistrationState state,
    required void Function(bool) setLoading,
  }) async {
    if (state.formKey.currentState!.validate()) {
      setLoading(true);
      try {
        // 1. Ambil token dari SharedPreferences (menggantikan cara lama)
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('user_token');

        if (token == null || token.isEmpty) {
          throw Exception("Sesi pengguna tidak valid. Silakan login kembali.");
        }

        if (state.selectedCoordinates == null) {
          throw Exception("Silakan pilih lokasi penjemputan di peta.");
        }

        // 2. Ambil shopId
        final shopId = await shopService.getCurrentShopId(_authService.currentUser);
        if (shopId == null) {
          throw Exception("ID Toko tidak ditemukan.");
        }

        // 3. Panggil updateShopDetails dengan menyertakan token
        // Catatan: Pastikan di dalam fungsi updateShopDetails, kamu menyisipkan token ini ke Header API
        await shopService.updateShopDetails(
          token: token, // <-- Kirim token ke service
          userId: _authService.currentUser?.uid ?? '',
          shopId: shopId,
          fullAddress: state.fullAddressController.text.trim(),
          coordinates: {
            'latitude': state.selectedCoordinates!.latitude,
            'longitude': state.selectedCoordinates!.longitude,
          },
        );
      } catch (e) {
        if (context.mounted) {
          showErrorDialog(
            context: context,
            message: e.toString().replaceAll("Exception: ", ""),
          );
        }
      } finally {
        setLoading(false);
      }
    }
  }

  /// Menangani aksi ketika kamera peta bergerak.
  /// Pin berada di tengah, jadi kita hanya perlu menyimpan koordinat tengah peta.
  void onCameraMove({
    required CameraPosition position,
    required ShopRegistrationState state,
  }) {
    // Setiap kali peta digeser, perbarui koordinat yang dipilih ke posisi tengah kamera.
    state.selectedCoordinates = position.target;
  }
}
