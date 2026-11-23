// lib/features/profile/user_profile.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/firebase/rtdb_service.dart';

import 'edit_profile.dart';
import 'widgets/user_profile_body.dart';

class UserProfileScreen extends StatelessWidget {
  final String? targetUid;

  const UserProfileScreen({super.key, this.targetUid});

  /// Menghitung lama masa kerja dari startDate hingga hari ini
  String _calculateTenure(DateTime startDate) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    if (startDate.isAfter(today)) {
      final int daysUntil = startDate.difference(today).inDays;
      return 'Mulai dalam $daysUntil hari';
    }

    int years = today.year - startDate.year;
    int months = today.month - startDate.month;
    int days = today.day - startDate.day;

    if (days < 0) {
      months -= 1;
      final DateTime prevMonth = DateTime(today.year, today.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    final List<String> parts = <String>[];
    if (years > 0) parts.add('$years tahun');
    if (months > 0) parts.add('$months bulan');
    if (days > 0 || parts.isEmpty) parts.add('$days hari');

    return parts.join(' ');
  }

  /// Membaca nilai string dari Map secara aman dengan fallback jika kosong
  String _readString(Map<dynamic, dynamic> map, String key, String fallback) {
    final String? val = map[key]?.toString().trim();
    return (val != null && val.isNotEmpty) ? val : fallback;
  }

  /// Membaca nilai angka (int) dari Map secara aman untuk kebutuhan seperti poin
  int _readInt(Map<dynamic, dynamic> map, String key, {int fallback = 0}) {
    final Object? raw = map[key];
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw != null) {
      return int.tryParse(raw.toString().trim()) ?? fallback;
    }
    return fallback;
  }

  /// Mengambil Map dari snapshot DatabaseEvent secara aman
  Map<dynamic, dynamic> _extractMap(AsyncSnapshot<DatabaseEvent> snapshot) {
    final Object? rawValue = snapshot.data?.snapshot.value;
    if (rawValue is Map) {
      return rawValue;
    }
    return <dynamic, dynamic>{};
  }

  /// Mengambil sub-map secara aman (misalnya untuk `attendance_summary`)
  Map<String, dynamic> _extractSubMap(
    Map<dynamic, dynamic> parentMap,
    String key,
  ) {
    final Object? rawChild = parentMap[key];
    if (rawChild is Map) {
      return rawChild.map(
        (dynamic k, dynamic v) => MapEntry<String, dynamic>(k.toString(), v),
      );
    }
    return <String, dynamic>{};
  }

  PreferredSizeWidget _buildAppBar({
    required BuildContext context,
    required String uid,
    required String displayName,
    required String employeeId,
    required String department,
    required String role,
    required String employmentStatus,
    required String email,
    required String phone,
    required String address,
    required DateTime? parsedStartDate,
    required String photoUrl,
    required String bannerUrl,
  }) {
    return AppBar(
      title: const Text('Profil Pekerja'),
      actions: [
        IconButton(
          tooltip: 'Edit Profil',
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => EditProfileScreen(
                  uid: uid,
                  initialName: displayName,
                  initialEmployeeId:
                      employeeId == 'Belum diatur' ? '' : employeeId,
                  initialEmail: email == 'Belum diatur' ? '' : email,
                  initialPhone: phone == 'Belum diatur' ? '' : phone,
                  initialDepartment:
                      department == 'Belum diatur' ? '' : department,
                  initialRole: role,
                  initialEmploymentStatus: employmentStatus,
                  initialAddress: address == 'Belum diatur' ? '' : address,
                  initialStartDate: parsedStartDate,
                  initialPhotoUrl: photoUrl,
                  initialBannerUrl: bannerUrl,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? uid = targetUid ?? rtdbService.currentUid;

    if (uid == null || uid.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil Pengguna')),
        body: const Center(
          child: Text('Silakan login terlebih dahulu untuk melihat profil.'),
        ),
      );
    }

    // Path terpusat data pekerja Matrix: members/matrix_member/$uid
    final DatabaseReference memberRef =
        rtdbService.ref('members/matrix_member/$uid');

    return StreamBuilder<DatabaseEvent>(
      stream: memberRef.onValue,
      builder: (context, snapshot) {
        final Map<dynamic, dynamic> memberData = _extractMap(snapshot);

        // Gambar profil & background profil dari members/matrix_member/$uid
        final String photoUrl = _readString(
          memberData,
          'photoUrl',
          currentUser?.photoURL?.trim() ?? '',
        );
        final String bannerUrl = _readString(
          memberData,
          'bannerUrl',
          '',
        );

        // Menyiapkan pembacaan awal attendance_summary & points untuk masa depan
        final Map<String, dynamic> attendanceSummary = _extractSubMap(
          memberData,
          'attendance_summary',
        );
        final int attendancePoints = _readInt(memberData, 'points', fallback: 0);

        // Contoh bacaan opsional di dalam attendance_summary jika sudah tersedia
        final int onTimeCount = _readInt(
          attendanceSummary,
          'onTimeCount',
          fallback: 0,
        );

        final String displayName = _readString(
          memberData,
          'name',
          (currentUser?.displayName?.trim().isNotEmpty == true)
              ? currentUser!.displayName!.trim()
              : 'Pengguna Matrix Sphere',
        );

        final String employeeId = _readString(
          memberData,
          'employeeId',
          'Belum diatur',
        );
        final String department = _readString(
          memberData,
          'department',
          'Belum diatur',
        );
        final String role =
            _readString(memberData, 'role', 'Staf / Karyawan');
        final String employmentStatus = _readString(
          memberData,
          'employmentStatus',
          'Belum diatur',
        );

        final String email = _readString(
          memberData,
          'email',
          (currentUser?.email?.trim().isNotEmpty == true)
              ? currentUser!.email!.trim()
              : 'Belum diatur',
        );

        final String phone = _readString(memberData, 'phone', 'Belum diatur');
        final String address = _readString(
          memberData,
          'address',
          'Belum diatur',
        );

        final String rawStartDate = _readString(memberData, 'startDate', '');
        final DateTime? parsedStartDate = parseIsoDate(rawStartDate);
        final String startDateDisplay = parsedStartDate != null
            ? '${formatIndonesianDate(parsedStartDate)} (${_calculateTenure(parsedStartDate)})'
            : 'Belum diatur';

        final bool isLoading =
            snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData;

        // Variabel attendanceSummary, attendancePoints, dan onTimeCount sudah siap
        // dipakai jika UserProfileBody ingin menampilkannya.
        debugPrint(
          '[UserProfileScreen] uid=$uid | points=$attendancePoints | onTime=$onTimeCount',
        );

        return Scaffold(
          appBar: _buildAppBar(
            context: context,
            uid: uid,
            displayName: displayName,
            employeeId: employeeId,
            department: department,
            role: role,
            employmentStatus: employmentStatus,
            email: email,
            phone: phone,
            address: address,
            parsedStartDate: parsedStartDate,
            photoUrl: photoUrl,
            bannerUrl: bannerUrl,
          ),
          body: UserProfileBody(
            isLoading: isLoading,
            uid: uid,
            displayName: displayName,
            photoUrl: photoUrl,
            bannerUrl: bannerUrl,
            role: role,
            department: department,
            employmentStatus: employmentStatus,
            startDateDisplay: startDateDisplay,
            employeeId: employeeId,
            email: email,
            phone: phone,
            address: address,
          ),
        );
      },
    );
  }
}