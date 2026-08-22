import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_models/shared_models.dart';
import 'package:shared_providers/shared_providers.dart';
import 'widgets/attendance_app_bar.dart';
import 'package:shared_utils/shared_utils.dart';
import 'package:shared_screens/shared_screens.dart';



class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceService _attendanceService = AttendanceService();
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  // LOKASI ADMIN (Dapat dimuat melalui API di kemudian hari)
  final OfficeLocationModel _officeLocation = OfficeLocationModel(
    latitude: -6.175392,
    longitude: 106.827153,
    allowedRadiusInMeters: 100.0,
  );

  Position? _currentPosition;
  double _distanceToOffice = 0.0;
  bool _isInRange = false;
  bool _isLoadingLocation = true;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _checkLocationAndPermission();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        final frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      AttendanceDialogs.showSnackBar(context, "Gagal menginisialisasi kamera: $e");
    }
  }

  Future<void> _checkLocationAndPermission() async {
    if (!mounted) return;
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      Position position = await _attendanceService.getCurrentLocation();
      double distance = _attendanceService.calculateDistance(position, _officeLocation);

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _distanceToOffice = distance;
          _isInRange = distance <= _officeLocation.allowedRadiusInMeters;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      AttendanceDialogs.showSnackBar(context, e.toString());
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _captureAndVerify() async {
    if (!_isInRange) {
      AttendanceDialogs.showSnackBar(context, "Anda berada di luar jangkauan kantor.");
      return;
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      XFile file = await _cameraController!.takePicture();

      bool success = await _attendanceService.uploadAttendanceData(
        imageFile: File(file.path),
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        employeeId: '12345', // ID Karyawan dinamis
      );

      if (success) {
        _handleSuccess();
      } else {
        AttendanceDialogs.showSnackBar(context, "Verifikasi gagal. Silakan coba kembali.");
      }
    } catch (e) {
      AttendanceDialogs.showSnackBar(context, "Terjadi kesalahan: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _handleSuccess() {
    AttendanceDialogs.showSuccess(
      context: context,
      onConfirm: () {
        Navigator.of(context).pop(); // Tutup dialog
        Navigator.of(context).pop(); // Kembali ke halaman utama
      },
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AttendanceAppBar(
        onRefreshLocation: _checkLocationAndPermission,
      ),
      body: _isCameraInitialized
          ? Stack(
              children: [
                // Live camera preview
                Positioned.fill(
                  child: CameraPreview(_cameraController!),
                ),
                // Overlay panduan wajah
                const FaceOverlay(),
                // Panel kontrol bawah
                ControlPanel(
                  isLoadingLocation: _isLoadingLocation,
                  isInRange: _isInRange,
                  distanceToOffice: _distanceToOffice,
                  isProcessing: _isProcessing,
                  onSubmit: (_isInRange && !_isLoadingLocation) ? _captureAndVerify : null,
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}