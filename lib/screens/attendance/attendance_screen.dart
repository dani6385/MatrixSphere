import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_components/shared_components.dart';
import 'package:shared_providers/shared_providers.dart';
import 'package:matrix_sphere/screens/attendance/components/attendance_appbar.dart';
import 'package:matrix_sphere/screens/attendance/components/attendance_body.dart';
//import 'package:matrix_sphere/features/settings/setting_screen.dart';
import 'package:matrix_sphere/core/utils/ui_helper.dart';

/// The main screen for the Attendance feature.
///
/// This widget acts as the root for the attendance feature, providing the [AttendanceViewModel]
/// to its children and housing the main UI structure.
class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Inisialisasi ViewModel dan panggil metode untuk memuat data awal.
      create: (_) => AttendanceViewModel()
        ..initCamera()
        ..pullAttendanceFromRtdb(),
      child: const AttendanceView(),
    );
  }
}

/// The main view for the Attendance screen.
///
/// This widget is responsible for the overall structure of the screen,
/// including the AppBar, Drawer, and the main body content which is
/// driven by the [AttendanceViewModel].
class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView>
    with TickerProviderStateMixin {
  late AnimationController _laserAnimationController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<AttendanceViewModel>();
    _laserAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(
          parent: _laserAnimationController, curve: Curves.easeInOut),
    );

    // Listen to one-time events from the ViewModel to show dialogs.
    viewModel.addListener(_handleViewModelEvents);
  }

  void _handleViewModelEvents() {
    final viewModel = context.read<AttendanceViewModel>();

    // Handle location error dialog
    if (viewModel.locationErrorEvent != null) {
      final event = viewModel.locationErrorEvent!;
      UiHelper.showLocationErrorDialog(context, event.title, event.message,
          showSettingsButton: event.needsSettings);
      viewModel.clearLocationErrorEvent(); // Clear the event after handling
    }

    // Handle scan success dialog
    if (viewModel.scanSuccessEvent != null) {
      final event = viewModel.scanSuccessEvent!;
      UiHelper.showScanSuccessDialog(context, message: event.message);
      viewModel.clearScanSuccessEvent(); // Clear the event after handling
    }
  }

  @override
  void dispose() {
    context.read<AttendanceViewModel>().disposeCamera();
    _laserAnimationController.dispose();
    context.read<AttendanceViewModel>().removeListener(_handleViewModelEvents);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      appBar: const AttendanceAppBar(),
      drawer: AppDrawerFactory.buildDrawer(
          side: DrawerSide.left, category: 'attendance'),
      endDrawer: AppDrawerFactory.buildDrawer(
          side: DrawerSide.right, category: 'attendance'),
      body: Consumer<AttendanceViewModel>(
        builder: (context, viewModel, child) {
          return AttendanceBody(
            isScanning: viewModel.isScanning,
            hasCameraPermission: viewModel.hasCameraPermission,
            isCheckingLocation: viewModel.isCheckingLocation,
            cameraController: viewModel.cameraController,
            laserAnimation: _laserAnimation,
            scanStatusMessage: viewModel.scanStatusMessage,
            scanProgress: viewModel.scanProgress,
            onCancelScan: viewModel.cancelScan,
            onRequestPermission: viewModel.requestCameraPermission,
            onClockIn: () => viewModel.startScan(isClockIn: true),
            onClockOut: () => viewModel.startScan(isClockIn: false),
            attendanceHistory: viewModel.attendanceList,
            onSync: viewModel.pullAttendanceFromRtdb,
          );
        },
      ),
    );
  }
}
