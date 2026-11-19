import 'dart:async';

import 'package:flutter/foundation.dart';

/// Mengubah sebuah [Stream] menjadi [Listenable] (`ChangeNotifier`) agar bisa
/// digunakan pada `GoRouter(refreshListenable: ...)`.
///
/// Contohnya di `app_router.dart`, stream `FirebaseAuth.instance.authStateChanges()`
/// dipantau sehingga `GoRouter` otomatis memeriksa ulang `redirect` ketika
/// status login pengguna berubah.
class RefreshStream extends ChangeNotifier {
  /// Membuat instance [RefreshStream] yang mendengarkan [stream][cite: 12].
  RefreshStream(Stream<dynamic> stream) {
    // Memberi tahu pendengar saat awal dibuat agar status awal langsung dicek
    notifyListeners();

    // Mengubah stream menjadi broadcast stream agar aman didengarkan
    // dan memicu `notifyListeners()` setiap kali ada event baru masuk[cite: 12].
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    // Menghentikan langganan stream saat objek dibuang agar memori tetap bersih[cite: 12]
    _subscription.cancel();
    super.dispose();
  }
}