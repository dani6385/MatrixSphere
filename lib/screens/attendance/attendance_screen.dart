import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_models/shared_models.dart';

import 'widgets/attendance_app_bar.dart';
import 'package:shared_utils/shared_utils.dart';
import 'widgets/attendance_body.dart';
// lib/screens/attendance_screen.dart
import 'package:shared_navigations/shared_navigations.dart'; // Menggunakan navigasi shared Anda
// Import helper item menu sesuai pola Anda
import 'widgets/attendance_drawer_items.dart';
import 'widgets/attendance_end_drawer_items.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceService _attendanceService = AttendanceService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  // LOKASI KANTOR (Konfigurasi Admin)
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
        employeeId: '12345',
      );

      if (success) {
        AttendanceDialogs.showSuccess(
          context: context,
          onConfirm: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
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

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Menonaktifkan gesture geser sesuai kebutuhan Anda
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      
      appBar: AttendanceAppBar(
        onRefreshLocation: _checkLocationAndPermission,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onOpenEndDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),

      // DRAWER KIRI (Menggunakan helper items)
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),

      // END DRAWER KANAN (Mengirimkan data GPS untuk ditampilkan di helper items)
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          return getEndDrawerSideMenuItems(
            context,
            currentRoute,
            officeLocation: _officeLocation,
            currentPosition: _currentPosition,
          );
        },
      ),

      body: AttendanceBody(
        isCameraInitialized: _isCameraInitialized,
        cameraController: _cameraController,
        isLoadingLocation: _isLoadingLocation,
        isInRange: _isInRange,
        distanceToOffice: _distanceToOffice,
        isProcessing: _isProcessing,
        onSubmit: (_isInRange && !_isLoadingLocation) ? _captureAndVerify : null,
      ),
    );
  }
}