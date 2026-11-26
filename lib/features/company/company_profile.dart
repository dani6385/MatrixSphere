import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:matrix_sphere/navigations/app_navigation.dart';
import 'package:shared_services/shared_services.dart';

import 'models/company_profile_model.dart';

/// Halaman Profil Perusahaan (`CompanyProfile`) dengan kontrol field lembur
/// eksklusif untuk Admin dan Manager Kepegawaian.
class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  static const String _permanentAdminUid = 'mjS1Y9Ll3JRQCMGSTK2oIBVIHT22';
  static const String _defaultCheckoutTime = '16:00';

  static const Map<int, String> _dayLabels = <int, String>{
    1: 'Senin',
    2: 'Selasa',
    3: 'Rabu',
    4: 'Kamis',
    5: 'Jumat',
    6: 'Sabtu',
    7: 'Minggu',
  };

  final TextEditingController _overtimeWorkController = TextEditingController();
  final FocusNode _overtimeFocusNode = FocusNode();

  late final DatabaseReference _companyRef;
  late final Stream<DatabaseEvent> _companyStream;
  late final Future<_AccessRoleResult> _accessRoleFuture;

  Timer? _clockTimer;
  String _lastSyncedOvertimeText = '';
  bool _isSavingOvertime = false;

  @override
  void initState() {
    super.initState();
    _companyRef = rtdbService.ref('company_profile');
    _companyStream = _companyRef.onValue;
    _accessRoleFuture = _resolveAccessRole(FirebaseAuth.instance.currentUser);

    // Evaluasi ulang status aktif/kedaluwarsa setiap 30 detik
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _overtimeWorkController.dispose();
    _overtimeFocusNode.dispose();
    super.dispose();
  }

  Future<_AccessRoleResult> _resolveAccessRole(User? user) async {
    if (user == null) {
      return const _AccessRoleResult(isAdmin: false, isHrManager: false);
    }

    bool isAdmin = user.uid == _permanentAdminUid;
    bool isHrManager = false;

    try {
      final IdTokenResult tokenResult = await user.getIdTokenResult(true);
      final Map<String, dynamic>? claims = tokenResult.claims;
      if (claims != null) {
        if (claims['admin'] == true || claims['isAdmin'] == true) {
          isAdmin = true;
        }
        final String claimRole =
            claims['role']?.toString().trim().toLowerCase() ?? '';
        if (claims['hrManager'] == true ||
            claims['isHrManager'] == true ||
            claims['managerKepegawaian'] == true ||
            claimRole == 'hr_manager' ||
            claimRole == 'manager_kepegawaian' ||
            claimRole == 'manager kepegawaian') {
          isHrManager = true;
        }
      }
    } catch (_) {
      // Lanjutkan pengecekan ke RTDB jika token claim gagal diambil
    }

    if (!isAdmin && !isHrManager) {
      try {
        final DataSnapshot memberSnap = await rtdbService.getSnapshot(
          'members/matrix_member/${user.uid}',
        );
        if (memberSnap.exists && memberSnap.value is Map) {
          final Map<dynamic, dynamic> memberData =
              memberSnap.value as Map<dynamic, dynamic>;
          final String role =
              memberData['role']?.toString().trim().toLowerCase() ?? '';
          final String position =
              memberData['position']?.toString().trim().toLowerCase() ?? '';
          final String department =
              memberData['department']?.toString().trim().toLowerCase() ?? '';

          if (role == 'admin' || memberData['isAdmin'] == true) {
            isAdmin = true;
          }
          if (role == 'hr_manager' ||
              role == 'manager_kepegawaian' ||
              role.contains('manager kepegawaian') ||
              position.contains('manager kepegawaian') ||
              position.contains('manajer kepegawaian') ||
              (department.contains('kepegawaian') &&
                  (position.contains('manager') ||
                      position.contains('manajer')))) {
            isHrManager = true;
          }
        }
      } catch (_) {
        // Abaikan jika node member tidak terbaca
      }
    }

    return _AccessRoleResult(isAdmin: isAdmin, isHrManager: isHrManager);
  }

  /// Mengekstrak batas waktu (jam & menit) dari teks lembur,
  /// mendukung format seperti "19:00", "19.00", "jam 7 malam", atau "jam 19".
  TimeOfDay? _extractDeadlineTime(String rawText) {
    final String text = rawText.trim().toLowerCase();
    if (text.isEmpty) return null;

    // 1. Format eksplisit HH:mm atau HH.mm (contoh: 19:00 atau 19.30)
    final RegExp hhmmRegex = RegExp(r'\b([01]?\d|2[0-3])[:.]([0-5]\d)\b');
    final RegExpMatch? hhmmMatch = hhmmRegex.firstMatch(text);
    if (hhmmMatch != null) {
      int hour = int.parse(hhmmMatch.group(1)!);
      final int minute = int.parse(hhmmMatch.group(2)!);
      if (hour >= 1 &&
          hour <= 11 &&
          (text.contains('malam') || text.contains('sore'))) {
        hour += 12;
      }
      return TimeOfDay(hour: hour, minute: minute);
    }

    // 2. Format "jam X" (contoh: "jam 7 malam", "jam 19", "sampai 8 malam")
    final RegExp hourWordRegex = RegExp(
      r'(?:jam|pukul|sampai|s\.d\.?)\s*([01]?\d|2[0-3])\b',
    );
    final RegExpMatch? hourMatch = hourWordRegex.firstMatch(text);
    if (hourMatch != null) {
      int hour = int.parse(hourMatch.group(1)!);
      if (hour >= 1 &&
          hour <= 11 &&
          (text.contains('malam') || text.contains('sore'))) {
        hour += 12;
      }
      return TimeOfDay(hour: hour, minute: 0);
    }

    return null;
  }

  bool _isOvertimeExpired(String rawText, int? savedAtMillis) {
    final String trimmed = rawText.trim();
    if (trimmed.isEmpty) return true;

    final DateTime now = DateTime.now();

    // Jika disimpan pada hari sebelumnya, lembur harian otomatis kedaluwarsa
    if (savedAtMillis != null && savedAtMillis > 0) {
      final DateTime savedDate =
          DateTime.fromMillisecondsSinceEpoch(savedAtMillis);
      final bool isDifferentDay = savedDate.year != now.year ||
          savedDate.month != now.month ||
          savedDate.day != now.day;
      if (isDifferentDay) return true;
    }

    final TimeOfDay? deadline = _extractDeadlineTime(trimmed);
    if (deadline == null) return false;

    final DateTime deadlineToday = DateTime(
      now.year,
      now.month,
      now.day,
      deadline.hour,
      deadline.minute,
    );
    return now.isAfter(deadlineToday);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final String h = time.hour.toString().padLeft(2, '0');
    final String m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _saveOvertimeWork(bool canEdit) async {
    if (!canEdit || _isSavingOvertime) return;

    final String text = _overtimeWorkController.text.trim();
    final TimeOfDay? parsedDeadline = _extractDeadlineTime(text);
    final bool hasText = text.isNotEmpty;
    final bool alreadyPassed = hasText && _isOvertimeExpired(text, null);
    final bool isActiveNow = hasText && !alreadyPassed;

    final String effectiveCheckout = isActiveNow && parsedDeadline != null
        ? _formatTimeOfDay(parsedDeadline)
        : _defaultCheckoutTime;

    setState(() => _isSavingOvertime = true);

    try {
      await _companyRef.update(<String, Object?>{
        'overtimeWork': isActiveNow ? text : '',
        'overtimeWorkActive': isActiveNow,
        'overtimeDeadline':
            isActiveNow && parsedDeadline != null ? _formatTimeOfDay(parsedDeadline) : null,
        'effectiveCheckoutTime': effectiveCheckout,
        'overtimeUpdatedAt': ServerValue.timestamp,
        'overtimeUpdatedBy': FirebaseAuth.instance.currentUser?.uid,
      });

      if (!mounted) return;
      _overtimeFocusNode.unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !hasText
                ? 'Field lembur dikosongkan. Jam pulang ditetapkan pada $_defaultCheckoutTime.'
                : alreadyPassed
                    ? 'Jam lembur sudah terlewati. Status nonaktif & jam pulang ditetapkan $_defaultCheckoutTime.'
                    : 'Jadwal lembur disimpan. Jam pulang efektif: $effectiveCheckout.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error, stack) {
      await rtdbService.logAppError(
        source: 'CompanyProfile._saveOvertimeWork',
        error: error,
        stackTrace: stack,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan jadwal lembur: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingOvertime = false);
      }
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().trim());
  }

  int _parseInt(dynamic value, {int fallback = 0}) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim()) ?? fallback;
  }

  bool _parseBool(dynamic value, {bool fallback = false}) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final String lower = value.toString().trim().toLowerCase();
    if (lower == 'true' || lower == '1') return true;
    if (lower == 'false' || lower == '0') return false;
    return fallback;
  }

  List<int> _parseWorkDays(dynamic raw) {
    if (raw is List) {
      final List<int> parsed = raw
          .map((e) => int.tryParse(e.toString().trim()) ?? 0)
          .where((d) => d >= 1 && d <= 7)
          .toSet()
          .toList()
        ..sort();
      if (parsed.isNotEmpty) return parsed;
    }
    return <int>[1, 2, 3, 4, 5];
  }

  String _formatWorkDaysLabel(List<int> days) {
    if (days.length == 5 &&
        days[0] == 1 &&
        days[1] == 2 &&
        days[2] == 3 &&
        days[3] == 4 &&
        days[4] == 5) {
      return 'Senin - Jumat';
    }
    return days
        .map((d) => _dayLabels[d] ?? '')
        .where((s) => s.isNotEmpty)
        .join(', ');
  }

  String _formatPhotoType(String? rawType) {
    switch (rawType?.trim()) {
      case 'front_selfie':
        return 'Kamera Depan (Selfie)';
      case 'rear_site':
        return 'Kamera Belakang (Bukti Lokasi/Kerja)';
      case 'both':
        return 'Kamera Depan & Belakang';
      default:
        return 'Kamera Depan (Selfie)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return FutureBuilder<_AccessRoleResult>(
      future: _accessRoleFuture,
      builder: (context, roleSnapshot) {
        final _AccessRoleResult access =
            roleSnapshot.data ?? const _AccessRoleResult(isAdmin: false, isHrManager: false);
        final bool isAdmin = access.isAdmin;
        final bool canManageOvertime = access.canManageOvertime;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profil Perusahaan'),
            actions: [
              if (isAdmin)
                IconButton(
                  tooltip: 'Edit Profil',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      AppNavigation.openEditCompanyProfile(context),
                ),
            ],
          ),
          body: StreamBuilder<DatabaseEvent>(
            stream: _companyStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              Map<dynamic, dynamic>? rawData;
              if (snapshot.hasData && snapshot.data!.snapshot.value is Map) {
                rawData =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              }

              final CompanyProfileModel company = CompanyProfileModel.fromMap(
                rawData,
              );

              final String matrixStart =
                  rawData?['matrixSphereWorkStart']?.toString() ?? '08:00';
              final String rawOvertimeWork =
                  rawData?['overtimeWork']?.toString().trim() ?? '';
              final int? overtimeUpdatedAt =
                  (rawData?['overtimeUpdatedAt'] as num?)?.toInt();

              // Cek apakah field lembur terisi dan belum melewati batas jam lembur
              final bool isExpired =
                  _isOvertimeExpired(rawOvertimeWork, overtimeUpdatedAt);
              final bool isOvertimeActive =
                  rawOvertimeWork.isNotEmpty && !isExpired;
              final TimeOfDay? overtimeDeadline =
                  isOvertimeActive ? _extractDeadlineTime(rawOvertimeWork) : null;

              // Jika field kosong atau sudah lewat jam lembur, jam pulang ditetapkan 16:00
              final String effectiveWorkEnd = isOvertimeActive
                  ? (overtimeDeadline != null
                      ? _formatTimeOfDay(overtimeDeadline)
                      : (rawData?['matrixSphereWorkEnd']?.toString() ??
                          _defaultCheckoutTime))
                  : _defaultCheckoutTime;

              // Sinkronkan controller jika tidak sedang diketik oleh pengguna
              final String displayFieldValue =
                  isOvertimeActive ? rawOvertimeWork : '';
              if (!_overtimeFocusNode.hasFocus &&
                  _lastSyncedOvertimeText != displayFieldValue) {
                _lastSyncedOvertimeText = displayFieldValue;
                _overtimeWorkController.text = displayFieldValue;
              }

              final List<int> workDays = _parseWorkDays(rawData?['workDays']);
              final String workDaysLabel = _formatWorkDaysLabel(workDays);

              // Dekrit Lembur Matrix Sphere & Kebijakan Lembur
              final bool overtimeDecreeEnabled = _parseBool(
                rawData?['overtimeDecreeEnabled'],
                fallback: false,
              );
              final String overtimeDecreeNumber =
                  rawData?['overtimeDecreeNumber']?.toString().trim() ?? '';
              final String overtimeDecreeNote =
                  rawData?['overtimeDecreeNote']?.toString().trim() ??
                      'Pekerja diperbolehkan mengambil lembur sesuai kebutuhan operasional berdasarkan dekrit resmi Matrix Sphere.';

              final bool allowWeekdayOvertime = _parseBool(
                rawData?['allowWeekdayOvertime'],
                fallback: true,
              );
              final String weekdayOvertimeEnd =
                  rawData?['weekdayOvertimeEnd']?.toString() ?? '21:00';

              final bool allowSaturdayOvertime = _parseBool(
                rawData?['allowSaturdayOvertime'],
                fallback: true,
              );
              final String saturdayStart =
                  rawData?['saturdayOvertimeStart']?.toString() ?? '08:00';
              final String saturdayEnd =
                  rawData?['saturdayOvertimeEnd']?.toString() ?? '17:00';

              final bool allowSundayOvertime = _parseBool(
                rawData?['allowSundayOvertime'],
                fallback: true,
              );
              final String sundayStart =
                  rawData?['sundayOvertimeStart']?.toString() ?? '08:00';
              final String sundayEnd =
                  rawData?['sundayOvertimeEnd']?.toString() ?? '17:00';

              // Kebutuhan absensi lokasi & kamera perusahaan
              final bool requireLocation = _parseBool(
                rawData?['requireLocationAttendance'],
                fallback: true,
              );
              final bool requirePhoto = _parseBool(
                rawData?['requirePhotoAttendance'],
                fallback: true,
              );
              final bool allowOutsideRadius = _parseBool(
                rawData?['allowOutsideRadius'],
                fallback: false,
              );
              final int graceMinutes = _parseInt(
                rawData?['graceMinutes'],
                fallback: 15,
              );
              final String photoTypeLabel = _formatPhotoType(
                rawData?['photoType']?.toString(),
              );

              // Baca koordinat titik pusat & radius absensi dari company_profile
              final double? officeLat = _parseDouble(
                rawData?['latitude'] ?? rawData?['lat'],
              );
              final double? officeLng = _parseDouble(
                rawData?['longitude'] ?? rawData?['lng'],
              );
              final double? radiusMeters = _parseDouble(
                rawData?['radiusMeters'] ??
                    rawData?['radius_meters'] ??
                    rawData?['radius'] ??
                    rawData?['attendanceRadius'],
              );

              final bool hasLocationConfig =
                  officeLat != null && officeLng != null;
              final String coordinateText = hasLocationConfig
                  ? '${officeLat.toStringAsFixed(6)}, ${officeLng.toStringAsFixed(6)}'
                  : 'Belum diatur';
              final String radiusText =
                  (radiusMeters != null && radiusMeters > 0)
                      ? '${radiusMeters.round()} meter'
                      : 'Belum diatur (default 100 meter)';

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: colorScheme.primaryContainer,
                          backgroundImage: company.hasLogo
                              ? NetworkImage(company.logoUrl!)
                              : null,
                          child: !company.hasLogo
                              ? Icon(
                                  Icons.apartment,
                                  size: 44,
                                  color: colorScheme.primary,
                                )
                              : null,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          company.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          company.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Field Khusus Overtime Work (Hanya Admin & Manager Kepegawaian)
                  _OvertimeWorkControlCard(
                    controller: _overtimeWorkController,
                    focusNode: _overtimeFocusNode,
                    canEdit: canManageOvertime,
                    isSaving: _isSavingOvertime,
                    isOvertimeActive: isOvertimeActive,
                    isExpired: rawOvertimeWork.isNotEmpty && isExpired,
                    effectiveCheckoutTime: effectiveWorkEnd,
                    onSave: () => _saveOvertimeWork(canManageOvertime),
                    onClear: () {
                      _overtimeWorkController.clear();
                      _saveOvertimeWork(canManageOvertime);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Ringkasan Hari Kerja (Senin - Jumat), Jam Kerja & Lokasi
                  _MatrixWorkHoursSummaryCard(
                    workDaysLabel: workDaysLabel,
                    workStart: matrixStart,
                    workEnd: effectiveWorkEnd,
                    isOvertimeActive: isOvertimeActive,
                    requireLocation: requireLocation,
                    requirePhoto: requirePhoto,
                    allowOutsideRadius: allowOutsideRadius,
                    graceMinutes: graceMinutes,
                    photoTypeLabel: photoTypeLabel,
                    coordinateText: coordinateText,
                    radiusText: radiusText,
                  ),
                  const SizedBox(height: 16),

                  _MatrixOvertimeDecreeCard(
                    decreeEnabled: overtimeDecreeEnabled || isOvertimeActive,
                    decreeNumber: overtimeDecreeNumber,
                    decreeNote: isOvertimeActive
                        ? 'Lembur aktif: $rawOvertimeWork (Jam pulang efektif: $effectiveWorkEnd)'
                        : overtimeDecreeNote,
                    regularEndTime: effectiveWorkEnd,
                    allowWeekdayOvertime: allowWeekdayOvertime,
                    weekdayOvertimeEnd: weekdayOvertimeEnd,
                    allowSaturdayOvertime: allowSaturdayOvertime,
                    saturdayStart: saturdayStart,
                    saturdayEnd: saturdayEnd,
                    allowSundayOvertime: allowSundayOvertime,
                    sundayStart: sundayStart,
                    sundayEnd: sundayEnd,
                  ),
                  const SizedBox(height: 24),

                  _CompanyInfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Telepon',
                    value: company.phone ?? 'Belum diatur',
                  ),
                  _CompanyInfoTile(
                    icon: Icons.location_on_outlined,
                    label: 'Alamat',
                    value: company.address ?? 'Belum diatur',
                  ),
                  _CompanyInfoTile(
                    icon: Icons.my_location_outlined,
                    label: 'Koordinat & Radius Absensi',
                    value: 'Titik: $coordinateText • Radius: $radiusText',
                  ),
                  _CompanyInfoTile(
                    icon: Icons.camera_alt_outlined,
                    label: 'Kebutuhan Lokasi & Kamera',
                    value:
                        'Lokasi: ${requireLocation ? 'Wajib' : 'Opsional'} • '
                        'Kamera: ${requirePhoto ? 'Wajib ($photoTypeLabel)' : 'Opsional'} • '
                        'Luar Radius: ${allowOutsideRadius ? 'Diizinkan (Review)' : 'Ditolak'}',
                  ),
                  _CompanyInfoTile(
                    icon: Icons.info_outline,
                    label: 'Deskripsi',
                    value:
                        company.description ??
                        'Belum ada deskripsi perusahaan.',
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _AccessRoleResult {
  final bool isAdmin;
  final bool isHrManager;

  const _AccessRoleResult({
    required this.isAdmin,
    required this.isHrManager,
  });

  bool get canManageOvertime => isAdmin || isHrManager;
}

class _OvertimeWorkControlCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool canEdit;
  final bool isSaving;
  final bool isOvertimeActive;
  final bool isExpired;
  final String effectiveCheckoutTime;
  final VoidCallback onSave;
  final VoidCallback onClear;

  const _OvertimeWorkControlCard({
    required this.controller,
    required this.focusNode,
    required this.canEdit,
    required this.isSaving,
    required this.isOvertimeActive,
    required this.isExpired,
    required this.effectiveCheckoutTime,
    required this.onSave,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: isOvertimeActive
          ? colorScheme.primaryContainer.withValues(alpha: 0.25)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isOvertimeActive ? colorScheme.primary : colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  size: 20,
                  color: isOvertimeActive
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Overtime Work (Lembur)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOvertimeActive
                        ? Colors.green.withValues(alpha: 0.15)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isOvertimeActive ? 'LEMBUR AKTIF' : 'NONAKTIF (PULANG 16:00)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isOvertimeActive
                          ? Colors.green.shade800
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Jam Pulang Efektif: $effectiveCheckoutTime'
              '${isExpired ? ' (Batas jam lembur sebelumnya sudah terlewati)' : ''}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isOvertimeActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: canEdit && !isSaving,
              readOnly: !canEdit,
              decoration: InputDecoration(
                labelText: 'Jadwal / Batas Lembur (Overtime Work)',
                hintText: 'Contoh: Lembur sampai jam 19:00',
                helperText: canEdit
                    ? 'Hanya Admin & Manager Kepegawaian. Kosongkan atau lewat jam lembur -> pulang 16:00.'
                    : 'Hanya dapat diisi oleh Manager Kepegawaian dan Admin.',
                helperMaxLines: 2,
                border: const OutlineInputBorder(),
                suffixIcon: (canEdit && controller.text.isNotEmpty)
                    ? IconButton(
                        tooltip: 'Kosongkan (Pulang 16:00)',
                        icon: const Icon(Icons.clear),
                        onPressed: isSaving ? null : onClear,
                      )
                    : null,
              ),
            ),
            if (canEdit) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: isSaving ? null : onClear,
                    child: const Text('Reset Pulang 16:00'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: isSaving ? null : onSave,
                    icon: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined, size: 18),
                    label: Text(isSaving ? 'Menyimpan...' : 'Simpan Lembur'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MatrixWorkHoursSummaryCard extends StatelessWidget {
  final String workDaysLabel;
  final String workStart;
  final String workEnd;
  final bool isOvertimeActive;
  final bool requireLocation;
  final bool requirePhoto;
  final bool allowOutsideRadius;
  final int graceMinutes;
  final String photoTypeLabel;
  final String coordinateText;
  final String radiusText;

  const _MatrixWorkHoursSummaryCard({
    required this.workDaysLabel,
    required this.workStart,
    required this.workEnd,
    required this.isOvertimeActive,
    required this.requireLocation,
    required this.requirePhoto,
    required this.allowOutsideRadius,
    required this.graceMinutes,
    required this.photoTypeLabel,
    required this.coordinateText,
    required this.radiusText,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hari Kerja, Lokasi & Aturan Absensi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hari Kerja Reguler: $workDaysLabel',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Jam Operasional: $workStart - $workEnd '
              '(${isOvertimeActive ? 'Termasuk Lembur' : 'Default Pulang 16:00'})',
            ),
            const SizedBox(height: 4),
            Text('Titik Koordinat: $coordinateText'),
            const SizedBox(height: 4),
            Text('Batas Radius: $radiusText'),
          ],
        ),
      ),
    );
  }
}

class _MatrixOvertimeDecreeCard extends StatelessWidget {
  final bool decreeEnabled;
  final String decreeNumber;
  final String decreeNote;
  final String regularEndTime;
  final bool allowWeekdayOvertime;
  final String weekdayOvertimeEnd;
  final bool allowSaturdayOvertime;
  final String saturdayStart;
  final String saturdayEnd;
  final bool allowSundayOvertime;
  final String sundayStart;
  final String sundayEnd;

  const _MatrixOvertimeDecreeCard({
    required this.decreeEnabled,
    required this.decreeNumber,
    required this.decreeNote,
    required this.regularEndTime,
    required this.allowWeekdayOvertime,
    required this.weekdayOvertimeEnd,
    required this.allowSaturdayOvertime,
    required this.saturdayStart,
    required this.saturdayEnd,
    required this.allowSundayOvertime,
    required this.sundayStart,
    required this.sundayEnd,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: decreeEnabled
          ? colorScheme.primaryContainer.withValues(alpha: 0.25)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: decreeEnabled
              ? colorScheme.primary
              : colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  decreeEnabled
                      ? Icons.gavel_rounded
                      : Icons.event_busy_outlined,
                  color: decreeEnabled
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: decreeEnabled
                        ? Colors.green.withValues(alpha: 0.15)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    decreeEnabled ? 'DEKRIT AKTIF' : 'NONAKTIF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: decreeEnabled
                          ? Colors.green.shade800
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              decreeEnabled
                  ? decreeNote
                  : 'Saat ini belum ada dekrit lembur aktif. Pekerja pulang pukul 16:00 sesuai jadwal Senin - Jumat.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (decreeEnabled) ...[
              const Divider(height: 20),
              Text(
                '• Lembur Hari Kerja (Senin - Jumat): '
                '${allowWeekdayOvertime ? 'Diizinkan s.d. $weekdayOvertimeEnd' : 'Tidak berlaku'}',
              ),
              const SizedBox(height: 4),
              Text(
                '• Lembur Hari Sabtu: '
                '${allowSaturdayOvertime ? 'Diizinkan ($saturdayStart - $saturdayEnd)' : 'Libur / Tidak berlaku'}',
              ),
              const SizedBox(height: 4),
              Text(
                '• Lembur Hari Minggu: '
                '${allowSundayOvertime ? 'Diizinkan ($sundayStart - $sundayEnd)' : 'Libur / Tidak berlaku'}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompanyInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CompanyInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(value),
        ),
      ),
    );
  }
}