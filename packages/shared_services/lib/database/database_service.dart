import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// 1. Impor Firebase Auth untuk mengambil ID pengguna yang sedang login
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:intl/intl.dart';
import 'package:shared_models/shared_models.dart';

class DatabaseService {
  // 2. Ubah _userId menjadi variabel dinamis yang bisa diatur
  final String _userId;
  late final DatabaseReference _attendanceRef;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 3. Perbarui konstruktor untuk menerima userId, atau ambil otomatis dari Firebase Auth jika kosong
  DatabaseService({String? userId}) 
      : _userId = userId ?? FirebaseAuth.instance.currentUser?.uid ?? "guest_user" {
    
    // Inisialisasi referensi database menggunakan ID pengguna yang dinamis
    _attendanceRef = FirebaseDatabase.instance.ref('attendance/$_userId');
  }

  Future<List<AttendanceRecord>> getAttendanceHistory() async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: 'get_attendance_history_called',
      );

      final snapshot = await _attendanceRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final records = data.values.map((recordJson) {
          return AttendanceRecord.fromJson(Map<String, dynamic>.from(recordJson as Map));
        }).toList();

        records.sort((a, b) => b.date.compareTo(a.date));
        return records;
      }
      return [];
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.log("Gagal mengambil riwayat absensi untuk user: $_userId");
      FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
      
      return [];
    }
  }

  Future<void> recordAttendance({required bool isClockIn}) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: isClockIn ? 'user_clock_in' : 'user_clock_out',
      );

      final now = DateTime.now();
      final dateKey = DateFormat('yyyy-MM-dd').format(now);
      final timeString = DateFormat('HH:mm').format(now);
      final recordRef = _attendanceRef.child(dateKey);

      final snapshot = await recordRef.get();

      if (isClockIn) {
        if (!snapshot.exists) {
          final newRecord = AttendanceRecord(
            date: now,
            clockInTime: timeString,
            status: now.hour > 8 ? 'Terlambat' : 'Hadir',
          );
          await recordRef.set(newRecord.toJson());
        }
      } else {
        if (snapshot.exists) {
          await recordRef.update({'clockOutTime': timeString});
        }
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.log("Gagal melakukan pencatatan absensi untuk user: $_userId");
      FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: false);
    }
  }

  Stream<Map<String, dynamic>?> getShopStream(String shopId) {
    return _firestore.collection('shops').doc(shopId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    }).handleError((error, stackTrace) {
      FirebaseCrashlytics.instance.log("Gagal mendengarkan stream shop ID: $shopId untuk user: $_userId");
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: false);
    });
  }
  Future<void> laporkanCrashKeDatabase({
  required String namaModul,
  required String pesanError,
}) async {
  try {
    final DatabaseReference crashRef = FirebaseDatabase.instance.ref('crashes');
    
    // Membuat node unik berdasarkan waktu/timestamp
    await crashRef.push().set({
      'modul': namaModul, // Contoh: 'seller_sphere' atau 'shop_sphere'
      'pesanError': pesanError,
      'waktu': DateTime.now().toIso8601String(),
      'status': 'pending',
    });
  } catch (e) {
    // ignore: avoid_print
    print("Gagal melaporkan crash ke RTDB: $e");
  }
}
}