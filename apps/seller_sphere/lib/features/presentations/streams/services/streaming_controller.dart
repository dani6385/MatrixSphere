import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'streaming_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seller_sphere/controllers/mixins/product_manager.dart'; // Import mixin yang baru dibuat

class StreamingController extends ChangeNotifier with ProductManager {
  final StreamingService _streamingService = StreamingService();

  // State dasar
  bool isInitialized = false;
  bool isStreaming = false;
  bool isFrontCamera = true;
  bool isMicMuted = false;
  bool isCameraBusy = false;
  String? errorMessage;

  final String streamId;
  final String rtmpUrl = "rtmp://broadcast.api.video/s/";
  
  StreamingController({required this.streamId});

  VoidCallback get toggleMute => () {
    _streamingService.toggleMute();
    isMicMuted = !isMicMuted;
    notifyListeners();
  };

  Future<void> _fetchStreamConfig() async {
    // Implementasi untuk mengambil konfigurasi stream lainnya jika ada
    // Untuk saat ini, biarkan kosong atau tambahkan logika yang relevan
  }

  Future<void> toggleStreaming() async {
    if (isStreaming) {
      await _streamingService.stopStreaming();
    } else {
      await _streamingService.startStreaming(rtmpUrl, streamId);
    }
    notifyListeners();
  }

  Future<void> switchCamera() async {
    isCameraBusy = true;
    notifyListeners();
    try {
      await _streamingService.switchCamera();
      isFrontCamera = !isFrontCamera;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isCameraBusy = false;
      notifyListeners();
    }
  }

  void sendChatMessage(String message) {
    // Implementasi pengiriman pesan chat
    // Misalnya, menggunakan Firebase Realtime Database atau layanan chat lainnya
    if (kDebugMode) {
      print('Sending chat message: $message');
    }
  }

  String get currentUserId {
    // Placeholder untuk mendapatkan ID pengguna saat ini
    // Di aplikasi nyata, ini akan diambil dari sesi pengguna yang login
    return 'user123';
  }

  get service => null;

  @override
  void dispose() {
    _streamingService.dispose();
    super.dispose(); // Panggil super.dispose() setelah membersihkan sumber daya
  }

  Future<void> init() async {
    // Memanggil fetchProducts dari mixin
    await Future.wait([
      fetchProducts(streamId, notifyListeners), 
      _fetchStreamConfig()
    ]);

    // Logika izin dan inisialisasi kamera tetap di sini agar controller tetap sinkron
    await _initializePermissionsAndCamera();
  }

  // Pindahkan definisi _initializePermissionsAndCamera ke luar dari init()
  Future<void> _initializePermissionsAndCamera() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.camera, Permission.microphone].request();
    if (statuses[Permission.camera] != PermissionStatus.granted) {
      errorMessage = "Izin kamera ditolak";
      notifyListeners();
      return;
    }

    _streamingService.initController(
      initialCamera: isFrontCamera ? 'front' : 'back',
      onConnectionSuccess: () { isStreaming = true; notifyListeners(); },
      onConnectionFailed: (error) { isStreaming = false; errorMessage = error; notifyListeners(); },
      onDisconnected: () { isStreaming = false; notifyListeners(); },
    );

    try {
      isCameraBusy = true; notifyListeners();
      await _streamingService.initializeCamera();
      isInitialized = true;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isCameraBusy = false; notifyListeners();
    }
  }

  // Fungsi lainnya (toggleStreaming, switchCamera, dsb) tetap di sini...
  // Dengan ini file utama akan jauh lebih ringkas!
}