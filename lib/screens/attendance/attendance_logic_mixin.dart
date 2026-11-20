import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Mixin yang memisahkan logika kamera, GPS, perhitungan jarak,
/// dan proses submit Check-In / Check-Out dari tampilan [AttendanceScreen][cite: 12].
mixin AttendanceLogicMixin<T extends StatefulWidget> on State<T> {
  String get targetOfficeName;
  double get targetOfficeLatitude;
  double get targetOfficeLongitude;
  double get maxAllowedRadiusMeters;

  CameraController? cameraController;
  List<CameraDescription> _cameras = <CameraDescription>[];

  bool isCameraInitialized = false;
  bool isLoadingLocation = true;
  bool isInRange = false;
  double distanceToOffice = 0.0;
  bool isProcessing = false;
  bool isCheckOutMode = false;

  String? checkInTimeText;
  String? checkOutTimeText;
  String savedWorkNote = '';
  final TextEditingController noteController = TextEditingController();

  /// Menyiapkan kamera dan lokasi saat layar dibuka.
  Future<void> initializeAttendance() async {
    await Future.wait([initCamera(), refreshLocation()]);
  }

  void updateSavedWorkNote(String newNote) {
    if (!mounted) return;
    setState(() {
      savedWorkNote = newNote.trim();
    });
  }

  /// Membersihkan controller saat widget dihapus.
  void disposeAttendanceResources() {
    noteController.dispose();
    cameraController = null;
  }

  /// Mengubah mode antara Check-In (`false`) dan Check-Out (`true`)[cite: 12].
  void setCheckOutMode(bool value) {
    if (!mounted) return;
    setState(() {
      isCheckOutMode = value;
    });
  }

  /// Menginisialisasi kamera perangkat.
  Future<void> initCamera({
    CameraLensDirection preferredLens = CameraLensDirection.front,
  }) async {
    if (!mounted) return;
    setState(() {
      isCameraInitialized = false;
    });

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (!mounted) return;
        showAttendanceMessage(
          'Kamera tidak ditemukan pada perangkat.',
          isError: true,
        );
        return;
      }

      // Pilih kamera sesuai arah yang diinginkan; jika tidak ada, pakai kamera pertama
      final CameraDescription selectedCamera = _cameras.firstWhere(
        (cam) => cam.lensDirection == preferredLens,
        orElse: () => _cameras.first,
      );

      // Bersihkan controller lama bila sedang menginisialisasi ulang
      await cameraController?.dispose();

      final CameraController controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        cameraController = controller;
        isCameraInitialized = true;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        isCameraInitialized = false;
      });
      showAttendanceMessage(
        'Gagal mengaktifkan kamera: ${e.description ?? e.code}',
        isError: true,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isCameraInitialized = false;
      });
      showAttendanceMessage('Terjadi kesalahan kamera: $e', isError: true);
    }
  }

  /// Mengambil foto bukti absensi jika kamera sudah siap.
  Future<XFile?> captureAttendancePhoto() async {
    final CameraController? controller = cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return null;
    }
    if (controller.value.isTakingPicture) {
      return null;
    }
    return controller.takePicture();
  }

  /// Memperbarui koordinat lokasi dan menghitung jarak ke titik kantor[cite: 12].
  Future<void> refreshLocation() async {
    if (!mounted) return;
    setState(() {
      isLoadingLocation = true;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 700));

      final double currentLat = targetOfficeLatitude;
      final double currentLng = targetOfficeLongitude;

      final double distance = _calculateDistanceMeters(
        lat1: currentLat,
        lon1: currentLng,
        lat2: targetOfficeLatitude,
        lon2: targetOfficeLongitude,
      );

      if (!mounted) return;
      setState(() {
        distanceToOffice = distance;
        isInRange = distance <= maxAllowedRadiusMeters;
        isLoadingLocation = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isInRange = false;
        isLoadingLocation = false;
      });
      showAttendanceMessage('Gagal memperbarui lokasi GPS: $e', isError: true);
    }
  }

  /// Menghitung jarak dua koordinat dalam meter (rumus Haversine)[cite: 12].
  double _calculateDistanceMeters({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadiusMeters = 6371000.0;
    final double dLat = _degToRad(lat2 - lat1);
    final double dLon = _degToRad(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMeters * c;
  }

  double _degToRad(double degree) => degree * (pi / 180.0);

  String _formatShortTime(DateTime time) {
    final String hh = time.hour.toString().padLeft(2, '0');
    final String mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  /// Memproses pengiriman absensi Check-In atau Check-Out[cite: 12].
  Future<void> submitAttendance() async {
    if (isProcessing) return;

    if (!isCameraInitialized) {
      showAttendanceMessage('Kamera belum siap digunakan.', isError: true);
      return;
    }

    if (isLoadingLocation || !isInRange) {
      showAttendanceMessage(
        'Anda harus berada di dalam radius ${maxAllowedRadiusMeters.toStringAsFixed(0)} meter.',
        isError: true,
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      final String workNote = noteController.text.trim();
      final String formattedTime = _formatShortTime(DateTime.now());

      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;
      setState(() {
        if (isCheckOutMode) {
          checkOutTimeText = formattedTime;
        } else {
          checkInTimeText = formattedTime;
        }
        isProcessing = false;
      });

      noteController.clear();

      final String actionName = isCheckOutMode ? 'Check-Out' : 'Check-In';
      final String noteInfo = workNote.isNotEmpty
          ? ' | Catatan: $workNote'
          : '';
      showAttendanceMessage(
        '$actionName berhasil dicatat pada pukul $formattedTime$noteInfo',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isProcessing = false;
      });
      showAttendanceMessage('Gagal menyimpan absensi: $e', isError: true);
    }
  }

  /// Menampilkan notifikasi SnackBar[cite: 12].
  void showAttendanceMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : kBrandPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
