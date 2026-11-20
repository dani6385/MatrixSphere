// lib/screens/attendance/attendance_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/features/company/models/company_profile_model.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:matrix_sphere/screens/attendance/widgets/app_drawer.dart';
import 'package:matrix_sphere/screens/attendance/widgets/app_enddrawer.dart';
import 'package:matrix_sphere/screens/attendance/widgets/attendance_appbar.dart';
import 'package:matrix_sphere/screens/attendance/widgets/attendance_body.dart';
import 'package:matrix_sphere/screens/attendance/widgets/work_note_bar.dart';
import 'package:matrix_sphere/screens/attendance/widgets/work_note_sheet.dart';
import 'package:shared_ui/shared_ui.dart';

import 'attendance_logic_mixin.dart';

/// Kerangka utama halaman Absensi Kerja (AttendanceScreen).
///
/// Bertugas menyusun struktur Scaffold (`AppBar`, `drawer`, `endDrawer`, dan `body`)
/// serta menghubungkan state dari [AttendanceLogicMixin] ke [AttendanceBody][cite: 12].
class AttendanceScreen extends StatefulWidget {
  /// Nama lokasi kantor / titik kerja.
  final String officeName;

  /// Latitude titik lokasi kantor/kerja.
  final double officeLatitude;

  /// Longitude titik lokasi kantor/kerja.
  final double officeLongitude;

  /// Radius maksimum yang diizinkan untuk absensi dalam meter.
  final double allowedRadiusMeters;

  const AttendanceScreen({
    super.key,
    this.officeName = 'Kantor / Lokasi Kerja Utama',
    this.officeLatitude = -6.200000,
    this.officeLongitude = 106.816666,
    this.allowedRadiusMeters = 100.0,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with AttendanceLogicMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  String get targetOfficeName => widget.officeName;

  @override
  double get targetOfficeLatitude => widget.officeLatitude;

  @override
  double get targetOfficeLongitude => widget.officeLongitude;

  @override
  double get maxAllowedRadiusMeters => widget.allowedRadiusMeters;

  @override
  void initState() {
    super.initState();
    initializeAttendance();
  }

  @override
  void dispose() {
    disposeAttendanceResources();
    super.dispose();
  }

  /// Membuka bottom sheet catatan kerja dan memperbarui tampilan bar catatan.
  Future<void> _handleOpenWorkNote() async {
    final String? updatedNote = await showWorkNoteSheet(
      context: context,
      initialNote: savedWorkNote,
      isCheckOutMode: isCheckOutMode,
      bottomBarClearance: 96.0,
    );
    if (updatedNote != null) {
      updateSavedWorkNote(updatedNote);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final DatabaseReference userRef = currentUser != null
        ? FirebaseDatabase.instance.ref('users/${currentUser.uid}')
        : FirebaseDatabase.instance.ref('dummy');
    final DatabaseReference companyRef = FirebaseDatabase.instance.ref(
      'company_profile',
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AttendanceAppBar(
        onRefreshLocation: refreshLocation,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onOpenEndDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
      ),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: _buildCompanyDrawer(context, companyRef),
      endDrawer: _buildUserEndDrawer(context, userRef, currentUser),
      body: Stack(
        children: [
          AttendanceBody(
            isCameraInitialized: isCameraInitialized,
            isLoadingLocation: isLoadingLocation,
            isInRange: isInRange,
            distanceToOffice: distanceToOffice,
            isProcessing: isProcessing,
            onSubmit: submitAttendance,
            officeName: widget.officeName,
            isCheckOutMode: isCheckOutMode,
            onModeChanged: setCheckOutMode,
            onRefreshLocation: refreshLocation,
            checkInTimeText: checkInTimeText,
            checkOutTimeText: checkOutTimeText,
            bottomSafeSpacing: 138.0,
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 84,
            child: WorkNoteBar(
              noteText: noteController.text.trim(),
              enabled: !isProcessing,
              onTap: _handleOpenWorkNote,
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun drawer kiri berisi profil perusahaan.
  Widget _buildCompanyDrawer(
    BuildContext context,
    DatabaseReference companyRef,
  ) {
    return StreamBuilder<DatabaseEvent>(
      stream: companyRef.onValue,
      builder: (context, snapshot) {
        Map<dynamic, dynamic>? rawCompanyData;
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          rawCompanyData =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }

        final company = CompanyProfileModel.fromMap(rawCompanyData);

        return SharedProjectDrawer(
          menuBuilder: (context, currentRoute) {
            return getDrawerSideMenuItems(context, currentRoute);
          },
          header: UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: company.hasLogo
                  ? NetworkImage(company.logoUrl!)
                  : null,
              child: !company.hasLogo
                  ? const Icon(Icons.apartment, size: 40, color: Colors.blue)
                  : null,
            ),
            accountName: Text(company.name),
            accountEmail: Text(company.email),
            onDetailsPressed: () {
              _scaffoldKey.currentState?.closeDrawer();
              AppNavigation.openCompanyProfile(context);
            },
          ),
        );
      },
    );
  }

  /// Membangun endDrawer kanan berisi profil pengguna.
  Widget _buildUserEndDrawer(
    BuildContext context,
    DatabaseReference userRef,
    User? currentUser,
  ) {
    return StreamBuilder<DatabaseEvent>(
      stream: userRef.onValue,
      builder: (context, snapshot) {
        Map<dynamic, dynamic> userData = {};
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          userData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }

        final String displayName =
            userData['name']?.toString() ??
            currentUser?.displayName ??
            'Pengguna MatrixSphere';
        final String email = currentUser?.email ?? 'user@email.com';
        final String? photoUrl =
            userData['photoUrl']?.toString() ?? currentUser?.photoURL;

        return SharedProjectDrawer(
          header: UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                  ? NetworkImage(photoUrl)
                  : null,
              child: (photoUrl == null || photoUrl.isEmpty)
                  ? const Icon(Icons.person, size: 40, color: Colors.blue)
                  : null,
            ),
            accountName: Text(displayName),
            accountEmail: Text(email),
            onDetailsPressed: () {
              _scaffoldKey.currentState?.closeEndDrawer();
              AppNavigation.openUserProfile(context);
            },
          ),
          menuBuilder: (context, currentRoute) {
            return getEndDrawerSideMenuItems(
              context,
              currentRoute,
              officeLocation: null,
              currentPosition: null,
            );
          },
        );
      },
    );
  }
}
