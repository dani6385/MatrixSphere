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

  /// Membaca nilai string dari Map dengan aman dan memakai fallback jika kosong
  String _readString(Map<dynamic, dynamic> map, String key, String fallback) {
    final String? val = map[key]?.toString().trim();
    return (val != null && val.isNotEmpty) ? val : fallback;
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

    final DatabaseReference memberRef = rtdbService.ref('matrix_members/$uid');

    return StreamBuilder<DatabaseEvent>(
      stream: memberRef.onValue,
      builder: (context, snapshot) {
        Map<dynamic, dynamic> memberData = <dynamic, dynamic>{};
        if (snapshot.hasData && snapshot.data!.snapshot.value is Map) {
          memberData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        }

        // URL gambar profil: utamakan dari database, lalu fallback ke FirebaseAuth
        final String photoUrl = _readString(
          memberData,
          'photoUrl',
          currentUser?.photoURL?.trim() ?? '',
        );

        // URL background/banner profil dari database
        final String bannerUrl = _readString(
          memberData,
          'bannerUrl',
          '',
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
        final String role = _readString(memberData, 'role', 'Staf / Karyawan');
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