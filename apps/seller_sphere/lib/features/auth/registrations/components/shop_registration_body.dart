
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
//import 'package:google_places_flutter/model/prediction.dart';
import 'package:shared_ui/shared_ui.dart';
import '../states/shop_registration_state.dart';
import '../logics/shop_registration_logic.dart';

class ShopRegistrationBody extends StatelessWidget {
  final ShopRegistrationState shopState;
  final ShopRegistrationLogic logic;
  final String googleApiKey;
  final VoidCallback onUpdate;

  const ShopRegistrationBody({
    super.key,
    required this.shopState,
    required this.logic,
    required this.googleApiKey,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    // Jika status adalah 'pending', tampilkan pesan status.
    if (shopState.shopStatus == 'pending') {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_top_rounded, size: 60, color: kWarmOrange),
            SizedBox(height: 16),
            Text(
              'Pendaftaran Toko Anda Sedang Ditinjau',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Harap tunggu, kami akan memberi notifikasi jika sudah disetujui.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Jika status 'none' atau null, tampilkan form pendaftaran.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Selamat datang! Mari daftarkan toko pertamamu untuk mulai berjualan di Seller Sphere.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Langkah 2: Lengkapi Detail Toko',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: shopState.shopNameController,
          decoration: const InputDecoration(labelText: 'Nama Toko'),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Nama toko tidak boleh kosong' : null,
        ),
        const SizedBox(height: 16),
        const Text("Alamat Lengkap"),
        const SizedBox(height: 8),
        GooglePlaceAutoCompleteTextField(
          textEditingController: shopState.fullAddressController, // Controller untuk input
          googleAPIKey: googleApiKey, // Kunci API Google Anda
          inputDecoration: const InputDecoration(hintText: "Cari alamat lengkap..."), // Dekorasi input
          debounceTime: 800, // Jeda waktu sebelum request API
          isLatLngRequired: false, // Tidak memerlukan LatLng saat item diklik
          // Gunakan LayerLink untuk memastikan posisi dropdown benar
          getPlaceDetailWithLatLng: (prediction) {
            // Fungsi ini dipanggil saat item dipilih
            shopState.fullAddressController.text = prediction.description ?? "";
            // Tutup keyboard secara manual setelah memilih
            FocusScope.of(context).unfocus();
          },
          itemClick: (prediction) {
            // Fungsi ini juga dipanggil, kita bisa kosongkan jika sudah ditangani di atas
          },
          // Builder untuk setiap item dalam daftar saran
          itemBuilder: (context, index, prediction) {
            return ListTile(
              title: Text(prediction.description ?? "Alamat tidak ditemukan"),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Sesuaikan dengan Alamat Anda:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: ShopRegistrationState.initialCameraPosition,
                  onMapCreated: (controller) => shopState.mapController = controller,
                  onCameraMove: (position) => logic.onCameraMove(
                    position: position,
                    state: shopState,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                const Icon(Icons.location_pin, color: kAlertRed, size: 50),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        shopState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () => logic.handleRegisterShop(
                  context: context,
                  state: shopState,
                  setLoading: (val) => onUpdate(),
                ),
                child: const Text('Daftarkan Toko'),
              ),
      ],
    );
  }
}