import 'dart:async';
import 'package:flutter/foundation.dart';

/// Sebuah kelas pembantu (*helper class*) untuk menjembatani *Stream* (seperti Firebase Auth state changes)
/// agar dapat dibaca oleh `refreshListenable` milik GoRouter.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    // Mendengarkan setiap ada perubahan data pada stream
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    // Membatalkan langganan stream saat tidak digunakan lagi untuk mencegah kebocoran memori (memory leak)
    _subscription.cancel();
    super.dispose();
  }
}